# sm_rabbitmq #

This is the sm_rabbitmq module. It provides...


# Table of Contents

* [Summary](#summary)
* [Class Parameters](#class-parameters)
   * [Users](#users)
   * [vHosts](#vhosts)
   * [Permissions](#permissions)
   * [Exchanges](#exchanges)
* [External References](#external-references)

## Summary
This module provides a common configuration for deploying and setting up RabbitMQ.  No further role based modules are required, just the necessary Hiera data values for over riding the class parameters.



## Class Parameters
Defaults
```
  $erlang_pkgversion      = 'R14B-04.3.el6'
  $rabbitmq_pkgversion    = '3.5.3-1'
  $manage_repos           = false
  $config_cluster         = true
  $cluster_nodes          = []
  $cluster_node_type      = 'disc'
  $service_manage         = true
  $amqp_port              = '5672'
  $amqp_mgmt_port         = '15672'
  $admin_enable           = true
  $delete_guest_user      = true

  $users                  = {}
  $vhosts                 = {}
  $permissions            = {}
  $exchanges              = {}

  $soft_limit             = '* soft nofile 32000'
  $hard_limit             = '* hard nofile 32000'
```
The default values will install the latest version of erlang and rabbitmq, as of the time of writing.  It is assumed that a cluster will be installed, single node clusters are fine and give the ability to scale when required.  Nodes will be 'disc' backed and not in memory and the standard ports for AMQP and management are used.  The guest user is removed for security.

The most important parameters are; $users, $vhosts, $permissions and $exchanges, and will be discussed in more detail below.  These parameters will deploy the custom RabbitMQ configuration that is required for your application messaging needs.

### Users
The example configuration (hiera data file) below creates the user 'bob' with the password 'p4s5w04d':
```
sm_rabbitmq::users:
    user1:
        username:   "bob"
        password:   "p4s5w04d"
        admin:      false
```
The admin value is by default set to false but shown here for illustration.

The hash key 'user1' can in fact be anything you like, so long as its valid text and a unique key name, and in most cases has no relevance.  However, when creating admin users which will be used for creating exchanges, this key is looked up in the ${module_name}::config::create_exchanges class.  

In this case, when creating an admin user which you will want to refer to in the exchanges configuration it would be better to set this to the username value, see 'bob_admin' below:
```
sm_rabbitmq::users:
    user1:
        username:   "bob"
        password:   "p4s5w04d"
        admin:      false
    bob_admin:
        username:   "bob_admin"
        password:   "secret-admin-password"
        admin:      true
```

### vHosts
The example configuration (hiera data file) below creates the vhost bobs_app and ensures that the vhost sids_test_app is removed.

```
sm_rabbitmq::vhosts:
    vhost1:   
        vhost:  "bobs_app"
    vhost2:   
        vhost:  "sids_test_app"
        ensure: absent
```
The 'ensure' value is by default set to present.

Key 'vhost' is required.

The hash keys 'vhost1' and 'vhost2' have no special meaning, any text can be used just ensure they are unique.

### Permissions
The example configuration (hiera data file) below sets permissions for user 'bob_admin' on vhost 'logstash' and on vhost 'sensu'.  The keys 'configure_permission', 'read_permission' and 'write_permission' give full access.  Further information on their possible values can be found at http://wwww.rabbitmq.com/

```
sm_rabbitmq::permissions:
    perm1:
        vhost:                  "logstash"
        username:               "bob_admin"
        configure_permission:   ".*"
        read_permission:        ".*"
        write_permission:       ".*"
    perm2:
        vhost:                  "sensu"
        username:               "bob_admin"
        configure_permission:   ".*"
        read_permission:        ".*"
        write_permission:       ".*"
```
All keys above are required.

### Exchanges
The example configuration (hiera data file) below defines two exchanges; exchange 'test_messages' on vhost 'logstash' and exchange 'test_alerts' on vhost 'sensu'.  The user bob_admin is used to create the exchanges.
```
sm_rabbitmq::exchanges:
    exchange1:
        vhost:          "logstash"
        exchange:       "test_messages"
        username:       "bob_admin"
        type:           "direct"
        internal:       false
        auto_delete:    false
        durable:        true
    exchange2:
        vhost:          "sensu"
        exchange:       "test_alerts"
        username:       "bob_admin"
        type:           "direct"
        internal:       false
        auto_delete:    false
        durable:        true
```
The keys 'type', 'internal', 'auto_delete' and 'durable' above are shown with their default values for illustration.

Required Keys are 'vhost', 'exchange' and 'username'.  The value for key 'username' is used for looking up the password in the hash ${module}::users[${username}][password].  

In the example above we are looking up the password for user 'bob_admin'.  This would be:

${module}::users[bob_admin][password]: "secret-admin-password"

## External References
This modules declares/includes the class ::rabbitmq from the module rabbitmq which in turn declares/includes the class staging from the module staging.
