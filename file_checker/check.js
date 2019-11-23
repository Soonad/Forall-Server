const fm = require("formality-lang")
const Minio = require("minio")
const fs = require("fs")

const minioClient = new Minio.Client({
  endPoint: process.env.BUCKET_HOST,
  port: +process.env.BUCKET_PORT,
  useSSL: process.env.BUCKET_SCHEME === "https://",
  accessKey: process.env.BUCKET_ACCESS_KEY,
  secretKey: process.env.BUCKET_SECRET_KEY
})

const bucket_name = process.env.BUCKET_NAME;

const build_imports = (full_names, tokens) => {
  const direct_imports =
    new Set(
      tokens
      .filter(([ctr, _]) => ctr == "imp")
      .map(([_, n]) => n)
    )

  return full_names.map((full_name) => ({
    ...parse_name(full_name),
    direct: direct_imports.has(full_name)
  }))
}

const parse_name = (name) => {
  const match = name.match(/([a-zA-Z0-9\._\-@]+)#([a-zA-Z0-9_\-]+)/)
  if(match) {
    return {name: match[1], version: match[2]}
  } else {
    throw "Invalid file format"
  }
};

const stream_to_string = (stream) => new Promise((resolve, reject) => {
  let data = ""
  stream.on("data", (chunk) => data += chunk)
  stream.on("end", () => resolve(data))
  stream.on("error", reject)
});

const load_from_bucket = async (full_name) => {
  const {name, version} = parse_name(full_name)
  const stream = await minioClient.getObject(bucket_name, `${name}/${version}.fm`)
  const data = await stream_to_string(stream)
  return data
};

const file = "local";

const is_local_def = (name) => name.indexOf(file) === 0
const local_def_names = (defs) => Object.keys(defs).filter(is_local_def)

module.exports = async (code) => {
  try {
    let full_names = []

    const loader = async (full_name) => {
      full_names.push(full_name)
      return await load_from_bucket(full_name)
    }

    const { defs, tokens } = await fm.lang.parse(code, {file, loader, tokenify: true})

    if(many_check(local_def_names(defs), defs)) {
      return {typechecks: true, imports: build_imports(full_names, tokens)}
    } else {
      return {typechecks: false}
    }
  } catch(e) {
    return {typechecks: false}
  }
}

const many_check = (names, defs) => names.find((name) => !def_check(name, defs)) === undefined

const def_check = (name, defs) => typechecks(name, defs) && annotated_type(name, defs)

const typechecks = (name, defs) => {
  try {
    fm.lang.typecheck(defs[name], null, {no_logs: true, defs})
    return true;
  } catch {
    return false;
  }
}

const annotated_type = (name, defs) => {
  return defs[name][0] == "Ann";
}

if(require.main == module) {
  const fs = require('fs')
  const process = require('process')

  const file = process.argv[2]
  const code = fs.readFileSync(file).toString()

  module.exports(code).then((x) => console.log(x))
}