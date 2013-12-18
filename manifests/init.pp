
#http://corefonts.sourceforge.net/

class msttfonts ($version = '2.5-1') {

  package { [ 'rpm-build', 'cabextract' ]:
    ensure => installed
  }

  exec {'download-msttcorefonts':
    command => "wget http://corefonts.sourceforge.net/msttcorefonts-${version}.spec",
    cwd     => '/tmp',
    path    => '/bin:/usr/bin',
    unless  => "test -f /tmp/msttcorefonts-${version}.spec",
  }

  exec {'rpm-build-msttcorefonts':
    command => "rpmbuild -ba msttcorefonts-${version}.spec",
    cwd     => '/tmp',
    path    => '/bin:/usr/bin',
    unless  => "test -f ${HOME}/rpmbuild/RPMS/noarch/msttcorefonts-${version}.noarch.rpm",
    require => [Exec['download-msttcorefonts'], Package['rpm-build']],
  }

  exec {'install-msttcorefonts':
    command => "yum localinstall -y --nogpgcheck msttcorefonts-${version}.noarch.rpm",
    cwd     => "${HOME}/rpmbuild/RPMS/noarch/",
    path    => '/bin:/usr/bin',
    unless  => 'fc-list | grep Arial',
    require => Exec['rpm-build-msttcorefonts'],
  }

  exec {'regenerate-font-cache':
    command => 'fc-cache -fv',
    path    => '/bin:/usr/bin',
    unless  => 'fc-list | grep Arial',
    require => Exec['install-msttcorefonts'],
  }

}
