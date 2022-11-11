setup() {
  set -eu -o pipefail
  # Fail early if old ddev is installed
  ddev debug capabilities | grep multiple-dockerfiles || exit 3
  export DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )/.."
  export TESTDIR=~/tmp/testbrowsersync
  mkdir -p $TESTDIR
  export PROJNAME=ddev-browsersync
  export DDEV_NON_INTERACTIVE=true
  ddev delete -Oy ${PROJNAME} || true
  cp tests/run-ddev-browsersync "${TESTDIR}"
  cd "${TESTDIR}"
  ddev config --project-name=${PROJNAME}
  echo "<html><head></head><body>this is a test</body>" >index.html
  ddev start -y
}

teardown() {
  set -eu -o pipefail
  cd ${TESTDIR} || ( printf "unable to cd to ${TESTDIR}\n" && exit 1 )
  ddev delete -Oy ${PROJNAME}
  [ "${TESTDIR}" != "" ] && rm -rf ${TESTDIR}
}

@test "install from directory" {
  set -eu -o pipefail
  cd ${TESTDIR}
  echo "# ddev get ${DIR} with project ${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
  ddev get ${DIR}
  ddev restart
  ./run-ddev-browsersync &
  sleep 5
  curl -s --fail https://${PROJNAME}.ddev.site:3000 | grep "this is a test"
}

@test "install from release" {
  set -eu -o pipefail
  cd ${TESTDIR} || ( printf "unable to cd to ${TESTDIR}\n" && exit 1 )
  echo "# ddev get drud/ddev-browsersync with project ${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
  ddev get drud/ddev-browsersync
  ddev restart
  # ./run-ddev-browsersync &
  # sleep 5
  # curl -s --fail https://${PROJNAME}.ddev.site:3000 | grep "this is a test"
}
