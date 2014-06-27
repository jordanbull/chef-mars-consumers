name             'mars'
maintainer       'EADP Mobile Platform Kitchener'
maintainer_email 'MobilePlatformKitchener@ea.com'
license          'All rights reserved'
description      'Installs and configures MARS Consumers'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends 's3_file'
#depends 'logstash'
depends 'jetty'
