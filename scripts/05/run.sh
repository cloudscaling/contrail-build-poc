#!/bin/bash -xe

my_file="$(readlink -e "$0")"
my_dir="$(dirname $my_file)"
source $my_dir/../common/functions

echo "INFO: start time $(date)"

export JOBS_COUNT=${JOBS_COUNT:-$(grep -c processor /proc/cpuinfo || echo 1)}
export WORKSPACE=${WORKSPACE:-$HOME}
cd $WORKSPACE
export CONTRAIL_BUILD_DIR=$WORKSPACE/build
export CONTRAIL_BUILDROOT_DIR=$WORKSPACE/buildroot
tar -xPf step-4.tgz
echo "INFO: end packing time $(date)"

pushd "$my_dir"
gitclone https://github.com/juniper/contrail-build tools/build
gitclone https://github.com/juniper/contrail-common src/contrail-common
gitclone https://github.com/juniper/contrail-controller controller
gitclone https://github.com/juniper/contrail-generateDS tools/generateds

test -L "./build" || ln -s $CONTRAIL_BUILD_DIR build
test -L "./buildroot" || ln -s $CONTRAIL_BUILDROOT_DIR buildroot

mkdir -p third_party
ln -s ../build/third_party/go third_party/go
ln -s ../build/third_party/cni_go_deps third_party/cni_go_deps

scons -j $JOBS_COUNT --root=$CONTRAIL_BUILDROOT_DIR install
scons -j $JOBS_COUNT --root=$CONTRAIL_BUILDROOT_DIR control-node:node_mgr
scons -j $JOBS_COUNT --root=$CONTRAIL_BUILDROOT_DIR vrouter:node_mgr
scons -j $JOBS_COUNT --root=$CONTRAIL_BUILDROOT_DIR opserver:node_mgr
scons -j $JOBS_COUNT --root=$CONTRAIL_BUILDROOT_DIR database:node_mgr
scons -j $JOBS_COUNT --root=$CONTRAIL_BUILDROOT_DIR src:nodemgr

rm -rf tools src controller

popd

echo "INFO: start packing time $(date)"
tar -czPf step-5.tgz $CONTRAIL_BUILD_DIR $CONTRAIL_BUILDROOT_DIR $HOME/rpmbuild/RPMS
rm -rf $CONTRAIL_BUILD_DIR $CONTRAIL_BUILDROOT_DIR $HOME/rpmbuild

echo "INFO: end time $(date)"
