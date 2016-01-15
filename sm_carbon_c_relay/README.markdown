# sm_carbon_c_relay #

This is the sm_carbon_c_relay module. It provides...

Carbon-like graphite line mode relay.

# Table of Contents

* [Summary](#summary)
* [Class Parameters](#class-parameters)
   * [Cluster Routes](#cluster-routes)
   * [Cluster Matches](#cluster-matches)
* [Usage](#usage)
* [External References](#external-references)

## Summary
This puppet role module enables the deployment and configuration of the carbon-c-relay tool, a replacement for
the orginal Graphite carbon-relay.

## Class Parameters
Default params.
```
  $port             = '2013'
  $workers          = '2'
  $cluster_routes   = [
    {
      name  =>  "send-through",
      type  =>  "forward",
      hosts =>  [ "127.0.0.1" ]
    }
  ]
  $cluster_matches  = [
    {
      pattern   => "*",
      send_to   => "send-through",
      stop      => true
    }
  
  ]
```
The default values above will setup the application to listen on port TCP 2013 (Graphite default for carbon-relay)
with 2 threads running.

The $cluster_routes array contains a hash for each configured route.  The default value here will forward all received metrics
to localhost on the standard Graphite carbon-cache port of TCP 2003.

The $cluster_matches array defines a hash for each rule that should correpsond to a cluster route 
defined above.  The default is to forward all metrics to the cluster route named "send-through".  On a successful 
match further processing stops.  Ommitting stop assumes a false value, so processing would continue.
 
## Usage
Only basic relaying will be covered here, for further information see [here](https://github.com/grobian/carbon-c-relay). 

### Cluster Routes
The hash object in a $cluster_routes element expects 3 keys:
  * name - a string
  * type - a string, should be one of the defined types (see link above for more information)
  * hosts - an array of hostname/ip[:port] strings

To forward matching metrics to 2 different graphite carbon-cache's on the default port the following could be used:
```
  $cluster_routes   = [
    {
      name  =>  "send-to-graphite",
      type  =>  "forward",
      hosts =>  [ "graphite-cache001", "graphite-cache002" ]
    }
  ]
```
To specify a different port just tag ":<port>" on the end, for example:
```
  $cluster_routes   = [
    {
      name  =>  "send-to-graphite",
      type  =>  "forward",
      hosts =>  [ "graphite-cache001:2103", "graphite-cache002:2104" ]
    }
  ]
```
Metrics would be forwarded to graphite-cache001 on port 2103, and graphite-cache002 on port 2104.

### Cluster Matches
The hash object in a $cluster_matches array element expects 3 keys:
  * pattern - a string containing a regular expression
  * send_to - a string containing the name of a cluster route defined in $cluster_routes
  * stop    - a boolean value
  
To ensure that metrics from server example001 ( key could be example001.load.one ) are sent to cluster route 
"send-to-graphite", the following match configuration could be used:
```
  $cluster_matches  = [
    {
      pattern   => "^example001",
      send_to   => "send-to-graphite"
    }
  ]
```
Any metric keys that started "example001" would match this rule and be forwarded on using the cluster route 
hash "send-to-graphite".
 
## Usage
All default values can be over ridden either when declaring the class or through Hiera.  The usage example below 
will use Hiera:

data/roles/carbon-c-relay.yaml
```
sm_carbon_c_relay::cluster_routes:
    -
        name:   "send-to-graphite"
        type:   "forward"
        hosts:
            -   "graphite-cache001"
            -   "graphite-cache002"
sm_carbon_c_relay::cluster_matches:
    -
        pattern:    "^example001"
        send_to:    "send-to-graphite"
        
```

manifest file
```
  class { 'sm_carbon_c_relay': }
```

## External References
Installs the package "carbon-c-relay" from a local yum repo.
