cd ~/srpms
/usr/bin/rpmbuild --rebuild ./lua.src.rpm

pushd ~/rpmbuild/RPMS/x86_64/
sudo /usr/bin/rpm -ivh lua-devel-*.el9.x86_64.rpm lua-5.*.el9.x86_64.rpm
popd

/usr/bin/rpmbuild --rebuild ./luarocks.src.rpm
