const {
    cp,
    rm,
    mkdir,
    exec
} = require('shelljs')
const { writeFileSync, readFileSync } = require('fs')
const glob = require('glob')

async function createRelease () {
  rm('-rf', 'dist')

  const ignoreGlobs = readFileSync('.gmodignore', 'utf-8')
        .split(/[\r\n]+/)
        .filter(Boolean)

  const folders = glob.sync('**/', {
    ignore: ignoreGlobs
  })
  
  mkdir('-p', 'dist/ps2-permaweaps')
  folders.map(x => mkdir('dist/ps2-permaweaps/' + x))

  const files = glob.sync('**', {
    ignore: ignoreGlobs,
    nodir: true
  })

  files.map(file => cp(file, 'dist/ps2-permaweaps/' + file))

  cp('package.json', 'dist')
  cp('.gmodignore', 'dist')
}

createRelease()
