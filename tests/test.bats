setup() {
  set -eu -o pipefail

  # Fail early if old ddev is installed
  ddev debug capabilities | grep multiple-dockerfiles >/dev/null || exit 3

  export DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )/.."
  export TESTDIR=~/tmp/test-browsersync
  mkdir -p "${TESTDIR}"
  export PROJNAME=test-browsersync
  export DDEV_NON_INTERACTIVE=true
  ddev delete -Oy ${PROJNAME} >/dev/null || true
  cp tests/run-ddev-browsersync "${TESTDIR}"
  cd "${TESTDIR}"
  ddev config --project-name=${PROJNAME}

  # Add simple page to test against.
  echo "<html><head></head><body>this is a test</body>" >index.html

  ddev start -y

  CURLCMD="curl -s --fail"
  # I can't currently get curl to trust mkcert CA on macOS
  if [[ "$OSTYPE" == "darwin"* ]]; then CURLCMD="curl -s -k --fail"; fi
}

teardown() {
  set -eu -o pipefail
  cd ${TESTDIR} || ( printf "unable to cd to ${TESTDIR}\n" && exit 1 )
  ddev delete -Oy ${PROJNAME}
  [ "${TESTDIR}" != "" ] && rm -rf ${TESTDIR}
}

healthcheck() {
  ${CURLCMD} https://${PROJNAME}.ddev.site:3000 | grep "this is a test"
}

@test "install from directory" {
  set -eu -o pipefail
  cd ${TESTDIR}
  echo "# ddev addon get ${DIR} with project ${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
  ddev addon get ${DIR}
  ddev restart
  ./run-ddev-browsersync &
  sleep 5

  # Check service works
  healthcheck
}

@test "install from release" {
  set -eu -o pipefail
  cd ${TESTDIR} || ( printf "unable to cd to ${TESTDIR}\n" && exit 1 )
  echo "# ddev addon get ddev/ddev-browsersync with project ${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
  ddev addon get ddev/ddev-browsersync
  ddev restart
  ./run-ddev-browsersync &
  sleep 5

  # Check service works
  healthcheck
}
