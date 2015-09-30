# Goldenseal -- _Hydrastis canadensis_
[![Build Status](https://travis-ci.org/curationexperts/goldenseal.svg?branch=master)](https://travis-ci.org/curationexperts/goldenseal)

## Installation

### Prerequisites:

* Goldenseal relies on [hydra-derivatives](https://github.com/projecthydra/hydra-derivatives) for derivative processing and needs the [required dependencies](https://github.com/projecthydra/hydra-derivatives#dependencies) installed
* redis

```
bin/setup
rake jetty:clean
rake curation_concerns:jetty:config
rake jetty:start
```

### Config:

* Configure ```config/initializers/curation_concerns.rb```

## Background Jobs

To start the redis server:
```
redis-server /usr/local/etc/redis.conf
```

To see the status of recent jobs in the browser console:
```
resque-web -N curation_concerns:development
```

To start worker(s) to run the jobs:
```
QUEUE=* VERBOSE=1 rake resque:work
```

## Run the test suite

* Make sure jetty is running
* `bundle exec rake spec`

## Run the rails server

* Make sure jetty is running
* Make sure redis is running
* `bin/rails s`

## Importing Records
### Importing Text records with TEI files

* Create a directory and add all the TEI files to that directory.
* Add all the attached files to the same directory.  You can organize them in sub-directories if you wish; They don't need to be in the top-level directory.
* From within the Rails root directory, run the import script:

```
script/import_text /path/to/the/dir/with/the/teis
```

Note:  The TEI files must be at the top level of the directory and must have a `.xml` file extension.  The importer will assume that any XML files found in the top-level directory are TEI files, and try to parse them.
