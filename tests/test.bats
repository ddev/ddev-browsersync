setup() {
  set -eu -o pipefail
  export DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )/.."
  export TESTDIR=~/tmp/testelasticsearch
  mkdir -p $TESTDIR
  export PROJNAME=test-addon-template
  export DDEV_NON_INTERACTIVE=true
  ddev delete -Oy ${PROJNAME} || true
  cd "${TESTDIR}"
  ddev config --project-name=${PROJNAME}
  ddev start
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
  # Do something here to verify functioning extra service
  # For extra credit, use a real CMS with actual config.
  # ddev exec "curl -s elasticsearch:9200" | grep "${PROJNAME}-elasticsearch"
}

@test "install from release" {
  set -eu -o pipefail
  cd ${TESTDIR} || ( printf "unable to cd to ${TESTDIR}\n" && exit 1 )
  echo "# ddev get drud/ddev-addon-template with project ${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
  ddev get drud/ddev-addon-template
  ddev restart
  # ddev exec "curl -s elasticsearch:9200" | grep "${PROJNAME}-elasticsearch"
}
