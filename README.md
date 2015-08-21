# Goldenseal -- _Hydrastis canadensis_
[![Build Status](https://travis-ci.org/curationexperts/goldenseal.svg?branch=master)](https://travis-ci.org/curationexperts/goldenseal)

## Installation

### Prerequisites:

* Fits (0.6.2) http://projects.iq.harvard.edu/files/fits/files/fits-0.6.2.zip

```
bin/setup
```

### Config:

* Configure ```config/initializers/curation_concerns.rb```

## Job monitoring

```
resque-web -N curation_concerns:development
```
