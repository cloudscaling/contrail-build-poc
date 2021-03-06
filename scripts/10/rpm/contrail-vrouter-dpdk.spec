%define _contrailetc  /etc/contrail
%define _distropkgdir %(pwd)/tools/packaging/common/control_files
%define _usr_bin /usr/bin/

%if 0%{?_buildTag:1}
%define _relstr %{_buildTag}
%else
%define _relstr %(date -u +%y%m%d%H%M)
%endif
%{echo: "Building release %{_relstr}\n"}
%if 0%{?_srcVer:1}
%define _verstr %{_srcVer}
%else
%define _verstr 1
%endif

Name:    contrail-vrouter-dpdk
Version: %{_verstr}
Release: %{_relstr}%{?dist}
Summary: Contrail vrouter DPDK %{?_gitVer}

Group:   Applications/System
License: Commercial
URL:     http://www.juniper.net/
Vendor:  Juniper Networks Inc

BuildRequires: liburcu2
Requires: liburcu2
Requires: contrail-vrouter-utils >= %{_verstr}-%{_relstr}

%description
Provides contrail-vrouter-dpdk binary

%install
# Install Directories
install -d -m 755 %{buildroot}/%{_usr_bin}
install -p -m 755 %{_builddir}/../build/production/vrouter/dpdk/contrail-vrouter-dpdk %{buildroot}/%{_usr_bin}/contrail-vrouter-dpdk

%files
%defattr(-,root,root,-)
%{_usr_bin}/contrail-vrouter-dpdk


%changelog
* Thu Feb 16 2017 Nagendra Maynattamai <npchandran@juniper.net> 4.1.1-2.1contrail1
- Initial Build. Rebuilt with patches for Opencontrail
