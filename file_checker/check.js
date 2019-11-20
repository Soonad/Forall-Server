const fm = require("formality-lang")

// For now we only accept files that doesn't import anything else
const loader = () => "";
const file = "local";

const is_local_def = (name) => name.indexOf(file) === 0
const local_def_names = (defs) => Object.keys(defs).filter(is_local_def)

module.exports = async (code) => {
  try {
    const { defs } = await fm.lang.parse(code, {file, loader})
    return many_check(local_def_names(defs), defs)
  } catch {
    return false
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