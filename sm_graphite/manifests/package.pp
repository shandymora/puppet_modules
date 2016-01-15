class sm_graphite::package (

) {
  package { 'httpd': ensure => $sm_graphite::package_ensure }
  package { 'mod_wsgi.x86_64': ensure => $sm_graphite::ensure }
  package { 'mod_python.x86_64': ensure => $sm_graphite::ensure }

  # Fonts/Bitmaps
  package { 'libXaw': ensure => $sm_graphite::ensure }
  package { 'xorg-x11-xbitmaps' : ensure => $sm_graphite::ensure }
  package { 'bitmap.x86_64': ensure => $sm_graphite::ensure }
  package { 'bitmap-fixed-fonts': ensure => $sm_graphite::ensure }
  package { 'urw-fonts': ensure => $sm_graphite::ensure }

  # Python modules
  package { 'python-devel.x86_64': ensure => $sm_graphite::ensure }
  package { 'python-pip.noarch': ensure => $sm_graphite::ensure }
  package { 'python-sqlite2.x86_64': ensure => $sm_graphite::ensure }
  package { 'pycairo.x86_64': ensure => $sm_graphite::ensure }
  package { 'pyOpenSSL': ensure => $sm_graphite::ensure }
  package { 'python-simplejson.x86_64': ensure => $sm_graphite::ensure }
  package { 'python-zope-interface.x86_64': ensure => $sm_graphite::ensure }
  package { 'python-twisted-web.x86_64': ensure => $sm_graphite::ensure }
  package { 'python-twisted': ensure => $sm_graphite::ensure }
  package { 'python-django-tagging': ensure => $sm_graphite::ensure }
  package { 'pytz': ensure => $sm_graphite::ensure }

  package { 'carbon': ensure => $sm_graphite::carbon_version }
  package { 'whisper': ensure => $sm_graphite::whisper_version }
  package { 'graphite-web': ensure => $sm_graphite::graphite_web_version }

}

