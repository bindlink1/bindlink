# New Relic Ruby Agent Release Notes #

## v5.4.0

  * Capacity analysis for multi-threaded dispatchers

    Metrics around capacity analysis did not previously account for multi-threaded
    dispatchers, and consequently could result in capacities of over 100% being
    recorded. This version now properly accounts for multi-threaded dispatchers.

  * `NewRelic::Agent.disable_transaction_tracing` deprecated

    `NewRelic::Agent.disable_transaction_tracing` has been deprecated. Users
    are encouraged to use `NewRelic::Agent.disable_all_tracing` or
    `NewRelic::Agent.ignore_transaction` instead.

  * Bugfix for SQL over-obfuscation

    A bug, introduced in v5.3.0, where SQL could be over-obfuscated for some
    database adapters has been fixed.

  * Bugfix for span event data in Resque processes

    A bug where span events would not be sent from Resque processes due to a
    missing endpoint has been fixed.

## v5.3.0 ##

  * Distributed Tracing

    Distributed tracing lets you see the path that a request takes as
    it travels through your distributed system. By showing the
    distributed activity through a unified view, you can troubleshoot
    and understand a complex system better than ever before.

    Distributed tracing is available with an APM Pro or equivalent
    subscription. To see a complete distributed trace, you need to
    enable the feature on a set of neighboring services. Enabling
    distributed tracing changes the behavior of some New Relic
    features, so carefully consult the
    [transition guide](https://docs.newrelic.com/docs/transition-guide-distributed-tracing)
    before you enable this feature.

    To enable distributed tracing, set the
    `distributed_tracing.enabled` configuration option to `true`.

## v5.2.0 ##

  * Use priority sampling for errors and custom events

    Priority sampling replaces the older reservoir event sampling method.
    With this change, the agent will maintain randomness across a given
    time period while improving coordination among transactions, errors,
    and custom events.

  * Bugfix for wrapping datastore operations

    The agent will now complete the process of wrapping datastore
    operations even if an error occurs during execution of a callback.

  * Span Events

    Finished segments whose `sampled` property is `true` will now post
    Span events to Insights.

## v5.1.0 ##

  * Rails 5.2 support

    The Ruby agent has been validated against the latest release of
    Ruby on Rails!

  * Support for newer libraries and frameworks

    We have updated the multiverse suite to test the agent against
    current versions of several frameworks.

  * Add `custom_attributes.enabled` configuration option

    This option is enabled by default. When it's disabled, custom
    attributes will not be transmitted on transaction events or error
    events.

  * Fix Grape load order dependency

    The agent will now choose the correct name for Grape transactions
    even if the customer's app loads the agent before Grape. Thanks
    to Daniel Doubrovkine for the contribution!

  * Add `webpacker:compile` to blacklisted tasks

    `webpacker:compile` is commonly used for compiling assets. It has
    been added to `AUTOSTART_BLACKLISTED_RAKE_TASKS` in the default
    configuration. Thanks to Claudio B. for the contribution!

  * Make browser instrumentation W3C-compliant

    `type="text/javascript"` is optional for the `<script>` tag under
    W3C. The `type` attribute has now been removed from browser
    instrumentation. Thanks to Spharian for the contribution!

  * Deferred `add_method_tracer` calls

    If a third-party library calls `add_method_tracer` before the
    agent has finished starting, we now queue these calls and run them
    when it's safe to do so (rather than skipping them and logging a
    warning).

  * Bugfix for Resque `around` / `before` hooks

    In rare cases, the agent was not instrumenting Resque `around` and
    `before` hooks. This version fixes the error.

  * Truncation of long stack traces

    Occasionally, long stack traces would cause complications sending
    data to New Relic. This version truncates long traces to 50 frames
    (split evenly between the top and bottom of the trace).

## v5.0.0 ##

  * SSL connections to New Relic are now mandatory

    Prior to this version, using an SSL connection to New Relic was
    the default behavior, but could be overridden. SSL connections are
    now enforced (not overrideable).

  * Additional security checking before trying to explain
    multi-statement SQL queries

    Customer applications might submit SQL queries containing multiple
    statements (e.g., SELECT * FROM table; SELECT * FROM table).  For
    security reasons, we should not generate explain plans in this
    situation.

    Although the agent correctly skipped explain plans for these
    queries during testing, we have added extra checks for this
    scenario.

  * Bugfix for RabbitMQ exchange names that are symbols

    The agent no longer raises a TypeError when a RabbitMQ exchange
    name is a Ruby symbol instead of a string.

  * Bugfix for audit logging to stdout

    Previous agents configured to log to stdout would correctly send
    regular agent logs to stdout, but would incorrectly send audit
    logs to a text file named "stdout".  This release corrects the
    error.

  * Bugfix for Capistrano deployment notifications on v3.7 and beyond

    Starting with version 3.7, Capistrano uses a different technique
    to determine a project's version control system.  The agent now
    works correctly with this new behavior. Thanks to Jimmy Zhang for
    the contribution.

## v4.8.0 ##

  * Initialize New Relic Agent before config initializers

  When running in a Rails environment, the agent registers an initializer that
  starts the agent. This initializer is now defined to run before config/initializers.
  Previously, the ordering was not specified for the initializer. This change
  guarantees the agent will started by the time your initializers run, so you can
  safely reference the Agent in your custom initializers. Thanks to Tony Ta for
  the contribution.

  * Ruby 2.5 Support

  The Ruby Agent has been verified to run under Ruby 2.5.

  * `request.uri` Collected as an Agent Attribute

  Users can now control the collection of `request.uri` on errors and transaction
  traces. Previously it was always collected without the ability to turn it off.
  It is now an agent attribute that can be controlled via the attributes config.
  For more information on agent attributes [see here](https://docs.newrelic.com/docs/agents/manage-apm-agents/agent-data/agent-attributes).

## 4.7.1 ##

  * Bugfix for Manual Browser Instrumentation

  There was a previous bug that required setting both `rum.enabled: false` and
  `browser.auto_instrument: false` to completely disable browser monitoring. An
  attempt to fix this in 4.7.0 resulted in breaking manual browser
  instrumentation. Those changes have been reverted. We will revisit this issue
  in an upcoming release.

## v4.7.0 ##

  * Expected Error API

  The agent now sends up `error.expected` as an intrinsic attribute on error
  events and error traces. When you pass `expected: true` to the `notice_error`
  method, both Insights and APM will indicate that the error is expected.

  * Typhoeus Hydra Instrumentation

  The agent now has request level visibility for HTTP requests made using
  Typhoeus Hydra.

  * Total Time Metrics are Recorded

  The agent now records Total Time metrics. In an application where segments
  execute concurrently, the total time can exceed the wall-clock time for a
  transaction. Users of the new Typhoeus Hydra instrumentation will notice
  this as changes on the overview page. Immediately after upgrading there
  will be an alert in the APM dashboard that states: "There are both old and
  new time metrics for this time window". This indicates that during that time
  window, some transactions report the total time metrics, while others do not.
  The message will go away after waiting for enough time to elapse and / or
  updating the time window.

  * Add `:message` category to `set_transaction_name` public API method

  The agent now permits the `:message` category to be passed into the public
  API method `set_transaction_name`, which will enable the transaction to be
  displayed as a messaging transaction.

  * Create `prepend_active_record_instrumentation` config option

  Users may now set the `prepend_active_record_instrumentation` option in
  their agent config to install Active Record 3 or 4 instrumentation using
  `Module.prepend` rather than `alias_method`.

  * Use Lazy load hooks for `ActionController::Base` and `ActionController::API`

  The agent now uses lazy load hooks to hook on `ActionController::Base` and
  `ActionController::API`. Thanks Edouard Chin for the contribution!

  * Use Lazy load hooks for `ActiveRecord::Base` and `ActiveRecord::Relation`

  The agent uses lazy load hooks when recording supportability metrics
  for `ActiveRecord::Base` and `ActiveRecord::Relation`. Thanks Joseph Haig
  for the contribution!

  * Check that `Rails::VERSION` is defined instead of just `Rails`

  The agent now checks that `Rails::VERSION` is defined since there are cases
  where `Rails` is defined but `Rails::VERSION` is not. Thanks to Alex Riedler
  and nilsding for the contribution!

  * Support fast RPC/direct reply-to in RabbitMQ

  The agent can now handle the pseudo-queue 'amq.rabbitmq.reply-to' in its
  Bunny instrumentation. Previously, using fast RPC led to a `NoMethodError`
  because the reply-to queue was expected to be a `Queue` object instead of
  a string.

## v4.6.0 ##

  * Public API for External Requests

  The agent now has public API for instrumenting external requests and linking
  up transactions via cross application tracing. See the [API Guide](https://docs.newrelic.com/docs/agents/ruby-agent/customization/ruby-agent-api-guide#externals)
  for more details this new functionality.

## v4.5.0 ##

  * Send synthetics headers even when CAT disabled

  The agent now sends synthetics headers whenever they are received from an
  external request, even if cross-application tracing is disabled.

  * Bugfix for DelayedJob Daemonization

  Customers using the delayed_job script that ships with the gem may encounter
  an IOError with a message indicating the stream was closed. This was due to
  the agent attempting to write a byte into a Pipe that was closed during the
  deamonization of the delayed_job script. This issue has been fixed.

  * Collect supportability metrics for public API

  The agent now collects Supportability/API/{method} metrics to track usage of
  all methods in the agent's public API.

  * Collect supportability metrics on `Module#prepend`

  The agent now collects Supportability/PrependedModules/{Module} metrics
  for ActiveRecord 4 and 5, ActionController 4 and 5, ActionView 4 and 5,
  ActiveJob 5, and ActionCable 5. These help track the adoption of the
  `Module#prepend` method so we can maintain compatibility with newer versions
  of Ruby and Rails.

  * Collect explain plans when using PostGIS ActiveRecord adapter

  The agent will now collect slow SQL explain plans, if configured to, on
  connections using the PostGIS adapter. Thanks Ari Pollak for the contribution!

  * Lazily intialize New Relic Config

  The agent will lazily initialize the New Relic config. This allows the agent
  to pickup configuration from environment variables set by dotenv and similar
  tools.

## v4.4.0 ##

  * Include test helper for 3rd party use

  In 4.2.0, all test files were excluded from being packaged in the gem. An
  agent class method `NewRelic::Agent.require_test_helper` was used by 3rd
  party gem authors to test extensions to the agent. The required file is now
  included in the gem.

  * Collect cloud metadata from Azure, GCP, PCF, and AWS cloud platform

  The agent now collects additional metadata when running in AWS, GCP, Azure, and
  PCF. This information is used to provide an enhanced experience when the agent
  is deployed on those platforms.

  * Install `at_exit` hook when running JRuby

  The agent now installs an `at_exit` hook when running JRuby, which wasn't
  done before because of constraints related to older JRuby versions that
  are no longer supported.

  * User/Utilization and System/Utilization metrics not recorded after Resque forks

  The agent no longer records invalid User/Utilization and System/Utilization
  metrics, which can lead to negative values, in forks of Resque processes.

  * Add `identifier` field to agent connect settings

  The agent now includes a unique identifier in its connect settings, ensuring
  that when multiple agents connect to multiple different apps, data are reported
  for each of the apps.

  * Clear transaction state after forking now opt-in

  The agent waits to connect until the first web request when it detects it's
  running in a forking dispatcher. When clearing the transaction state in this
  situation we lose the first frame of the transaction and the subsequent
  trace becomes corrupted. We've made this feature opt-in and is turned off by
  default. This behavior only affects the first transaction after a dispatcher
  forks.

## v4.3.0 ##

  * Instrumentation for the Bunny AMQP Client

  The Bunny AMQP Client is now automatically instrumented. The agent will
  report data for messages sent and received by an application. Data on messages
  is available in both APM and Insights. Applications connected through a
  RabbitMQ exchange will now also be visible on Service Maps as part of Cross
  Application Tracing. See the [message queues documentation page](https://docs.newrelic.com/docs/agents/ruby-agent/features/message-queues)
  for more details.

  * Safely normalize external hostnames

  The agent has been updated to check for nil host values before downcasing the
  hostname. Thanks Rafael Val??rio for the contribution!

  * PageView events will not be generated for ignored transactions

  The agent now checks if transaction is ignored before injecting the New Relic
  Browser Agent. This will prevent PageView events from being generated for
  ignored transactions.

  * Datastores required explicitly in agent

  The agent has been modified to explicity `require` the Datastores module
  whereas previously there were situations where the module could be
  implicitly defined. Thanks Kevin Griffin for the contribution!

  * Clear transaction state after forking

  Previously, if a transaction was started and the process forks, the transaction
  state survived the fork and `#after_fork` call in thread local storage. Now,
  this state is cleared by `#after_fork`.

  * Postgis adapter reports as Postgres for datastores

  The agent now maps the Postgis adapter to Postgres for datastore metrics.
  Thanks Vojt??ch Vondra for the contribution!

  * Deprecate `:trace_only` option

  The `NewRelic::Agent.notice_error` API has been updated to deprecate the
  `:trace_only` option in favor of `:expected`.

## v4.2.0 ##

  * Sinatra 2.0 and Padrino 0.14.x Support

  The agent has been verified against the latest versions of Sinatra and Padrino.

  * Rails 5.1 Support

  The Ruby agent has been validated against the latest release of Ruby on Rails!

  * APP_ENV considered when determining environment

  The agent will now consider the APP_ENV environment when starting up.

  * Test files excluded from gem

  The gemspec has been updated to exclude test files from being packaged into the
  gem. Thanks dimko for the contribution!

## v4.1.0 ##

  * Developer Mode removed

  The Ruby Agent's Developer Mode, which provided a very limited view of your
  application performance data, has been removed. For more information, check
  out our [community forum](https://discuss.newrelic.com/t/feedback-on-the-ruby-agent-s-developer-mode/46957).

  * Support NEW_RELIC_ENV for Rails apps

  Previously, users could set the agent environment with NEW_RELIC_ENV only
  for non-Rails apps. For Rails app, the agent environment would use whatever
  the Rails environment was set to. Now, NEW_RELIC_ENV can also be used for
  Rails apps, so that it is possible to have an agent environment that is
  different from the Rails environment. Thanks Andrea Campolonghi for the
  contribution, as well as Steve Schwartz for also looking into this issue!

  * Normalization of external hostnames

  Hostnames from URIs used in external HTTP requests are now always downcased
  to prevent duplicate metrics when only case is different.

## v4.0.0 ##

  * Require Ruby 2.0.0+

  The agent no longer supports Ruby versions prior to 2.0, JRuby 1.7 and
  earlier, and all versions of Rubinius. Customers using affected Rubies
  can continue to run 3.x agent versions, but new features or bugfixes
  will not be published for 3.x agents. For more information, check out our
  [community forum](https://discuss.newrelic.com/t/support-for-ruby-jruby-1-x-is-being-deprecated-in-ruby-agent-4-0-0/44787).

  * OkJson vendored library removed

  Ruby 1.8 did not include the JSON gem by default, so the agent included a
  vendored version of [OkJson](https://github.com/kr/okjson) that it would fall
  back on using in cases where the JSON gem was not available. This has been
  removed.

  * YAJL workaround removed

  [yajl-ruby](https://github.com/brianmario/yajl-ruby) versions prior to 1.2 had
  the potential to cause a segmentation fault when working large, deeply-nested
  objects like thread profiles. If you are using yajl-ruby with the `JSON`
  monkey patches enabled by requiring `yajl/json_gem`, you should upgrade to
  at least version 1.2.

  * Deprecated APIs removed

    * `Agent.abort_transaction!`
    * `Agent.add_custom_parameters`
    * `Agent.add_request_parameters`
    * `Agent.browser_timing_footer`
    * `Agent.get_stats`
    * `Agent.get_stats_no_scope`
    * `Agent.record_transaction`
    * `Agent.reset_stats`
    * `Agent.set_user_attributes`
    * `Agent::Instrumentation::Rack`
    * `ActionController#newrelic_notice_error`
    * `ActiveRecordHelper.rollup_metrics_for` (may be incompatible with newrelic_moped)
    * `Instrumentation::MetricFrame.recording_web_transaction?`
    * `Instrumentation::MetricFrame.abort_transaction!`
    * `MethodTracer.get_stats_scoped`
    * `MethodTracer.get_stats_unscoped`
    * `MethodTracer.trace_method_execution`
    * `MethodTracer.trace_method_execution_no_scope`
    * `MethodTracer.trace_method_execution_with_scope`
    * `MetricSpec#sub`
    * `MetricStats#get_stats`
    * `MetricStats#get_stats_no_scope`
    * `NoticedError#exception_class`
    * `Rack::ErrorCollector`
    * `StatsEngine::Samplers.add_sampler`
    * `StatsEngine::Samplers.add_harvest_sampler`

  The above methods have had deprecation notices on them for some time and
  have now been removed. Assistance migrating usage of these APIs is
  available at https://docs.newrelic.com/node/2601.

  The agent no longer deletes deprecated keys passed to `add_method_tracer`. Passing
  in deprecated keys can cause an exception. Ensure that you are not passing any of
  the following keys: `:force, :scoped_metric_only, :deduct_call_time_from_parent`
  to `add_method_tracer`.

  The agent no longer deletes deprecated keys passed in as options to
  `NewRelic::Agent.notice_error`. If you are passing any of these deprecated
  keys: `:request_params, :request, :referer` to the `notice_error` API, please
  delete them otherwise they will be collected as custom attributes.

  * Error handling changes

  The agent now only checks for `original_exception` in environments with Rails
  versions prior to 5. Checking for `Exception#cause` has been removed. In addition,
  the agent now will match class name with message and backtrace when noticing
  errors that have an `original_exception`.

## v3.18.1 ##

  * Ensure Mongo aggregate queries are properly obfuscated

  Instrumentation for the Mongo 2.x driver had a bug where the `pipeline`
  attribute of Mongo aggregate queries was not properly obfuscated. Users
  who have sensitive data in their `aggregate` queries are strongly encouraged
  to upgrade to this version of the agent. Users who are unable to upgrade are
  encouraged to turn off query collection using by setting
  `mongo.capture_queries` to false in their newrelic.yml files.

  This release fixes [New Relic Security Bulletin NR17-03](https://docs.newrelic.com/docs/accounts-partnerships/accounts/security-bulletins/security-bulletin-nr17-03).

  * Early access Redis 4.0 instrumentation

  Our Redis instrumentation has been tested against Redis 4.0.0.rc1.

## v3.18.0 ##

  * Ruby 2.4.0 support

  The agent is now tested against the official release of ruby 2.4.0,
  excluding incompatible packages.

  * Agent-based metrics will not be recorded outside of active transactions

  The agent has historically recorded metrics outside of a transaction. In
  practice, this usually occurs in applications that run background job
  processors. The agent would record metrics for queries the
  background job processor is making between transactions. This can lead
  to display issues on the background overview page and the presence of
  metrics generated by the background job processor can mask the application
  generated metrics on the database page. The agent will no longer generate
  metrics outside of a transaction. Custom metrics recorded using
  `NewRelic::Agent.record_metric` will continue to be recorded regardless
  of whether there is an active transaction.

  * Include ControllerInstrumentation module with ActiveSupport.on_load

  The agent will now use the `on_load :action_controller` hook to include
  the ControllerInstrumentation module in to both the `Base` and `API`
  classes of ActionController for Rails 5. This ensures that the proper
  load order is retained, minimizing side-effects of having the agent in
  an application.

  * Ensure values for revisions on Capistrano deploy notices

  Previously, running the task to look up the changelog could
  generate an error, if there weren't previous and current revisions
  defined. This has now been fixed. Thanks Winfield Peterson for the
  contribution!

  * External Segment Rewrites

  The agent has made internal changes to how it represents segments for
  external web requests.

## v3.17.2 ##

  * compatibility with ruby 2.4.0-preview3

  the ruby agent has been updated to work on ruby 2.4.0-preview3.

  * Early Access Sinatra 2.0 instrumentation

  Our Sinatra instrumentation has been updated to work with Sinatra
  2.0.0.beta2.

  * Include controller instrumentation module in Rails 5 API

  The agent now includes the ControllerInstrumentation module into
  ActionController::API. This gives Rails API controllers access to
  helper methods like `newrelic_ignore` in support of the existing
  event-subscription-based action instrumentation. Thanks Andreas
  Thurn for the contribution!

  * Use Module#prepend for ActiveRecord 5 Instrumentation

  Rails 5 deprecated the use of `alias_method_chain` in favor of using
  `Module#prepend`. Mixing `Module#prepend` and `alias_method_chain`
  can lead to a SystemStackError when an `alias_method_chain` is
  applied after a module has been prepended. This should ensure
  better compatibility between our ActiveRecord Instrumentation and
  other third party gems that modify ActiveRecord using `Module#prepend`.

  * Use license key passed in to NewRelic::Agent.manual_start

  Previously, the license key passed in when manually starting the agent
  with NewRelic::Agent.manual_start was not referenced when setting up
  the connection to report data to New Relic. This is now fixed.

  * Account for DataMapper database connection errors

  Our DataMapper instrumentation traces instances of DataObjects::SQLError
  being raised and removes the password from the URI attribute. However,
  when DataObjects cannot connect to the database (ex: could not resolve
  host), it will raise a DataObjects::ConnectionError. This inherits from
  DataObjects::SQLError but has `nil` for its URI attribute, since no
  connection has been made yet. To avoid the password check here on `nil`,
  the agent catches and re-raises any instances of DataObjects::ConnectionError
  explicitly. Thanks Postmodern for this contribution!

  * Account for request methods that require arguments

  When tracing a transaction, the agent tries to get the request object
  from a controller if it wasn't explicitly passed in. However, this posed
  problems in non-controller transactions with their own `request` methods
  defined that required arguments, such as in Resque jobs. This is now fixed.

## v3.17.1 ##

  * Datastore instance reporting for Redis, MongoDB, and memcached

  The agent now collects datastore instance information for Redis, MongoDB,
  and memcached. This information is displayed in transaction traces and slow
  query traces. For memcached only, multi requests will expand to individual
  server nodes, and the operation and key(s) will show in the trace details
  "Database query" section. Metrics for `get_multi` nodes will change slightly.
  Parent nodes for a `get_multi` will be recorded as generic segments. Their
  children will be recorded as datastore segments under the name
  `get_multi_request` and represent a batch request to a single Memcached
  instance.

  * Rescue errors from attempts to fetch slow query explain plans

  For slow queries through ActiveRecord 4+, the agent will attempt to fetch
  an explain plan on SELECT statements. In the event that this causes an
  error, such as being run on an adapter that doesn't implement `exec_query`,
  the agent will now rescue and log those errors.

## v3.17.0 ##

  * Datastore instance reporting for ActiveRecord

  The agent now collects database instance information for ActiveRecord operations,
  when using the MySQL and Postgres adapters.  This information (database server
  and database name) is displayed in transaction traces and slow query traces.

## v3.16.3 ##

  * Add `:trace_only` option to `notice_error` API

  Previously, calling `notice_error` would record the trace, increment the
  error count, and consider the transaction failing for Apdex purposes. This
  method now accepts a `:trace_only` boolean option which, if true, will only
  record the trace and not affect the error count or transaction.

  * HTTP.rb support

  The agent has been updated to add instrumentation support for the HTTP gem,
  including Cross Application Tracing. Thanks Tiago Sousa for the contribution!

  * Prevent redundant Delayed::Job instrumentation installation

  This change was to handle situations where multiple Delayed::Worker instances
  are being created but Delayed::Job has already been instrumented. Thanks Tony
  Brown for the contribution!

## v3.16.2 ##

  * Fix for "Unexpected frame in traced method stack" errors

  Our ActiveRecord 4.x instrumentation could have generated "Unexpected frame in
  traced method stack" errors when used outside of an active transaction (for
  example, in custom background job handlers). This has been fixed.

## v3.16.1 ##

  * Internal datastore instrumentation rewrites

  The agent's internal tracing of datastore segments has been rewritten, and
  instrumentation updated to utilize the new classes.

  * Fix Grape endpoint versions in transaction names

  Grape 0.16 changed Route#version (formerly #route_version) to possibly return
  an Array of versions for the current endpoint. The agent has been updated to
  use rack.env['api.version'] set by Grape, and fall back to joining the version
  Array with '|' before inclusion in the transaction name when api.version is
  not available. Thanks Geoff Massanek for the contribution!

  * Fix deprecation warnings from various Rails error subclasses

  Rails 5 deprecates #original_exception on a few internal subclasses of
  StandardError in favor of Exception#cause from Ruby stdlib. The agent has
  been updated to try Exception#cause first, thus avoiding deprecation
  warnings. Thanks Alexander Stuart-Kregor for the contribution!

  * Fix instrumentation for Sequel 4.35.0

  The latest version of Sequel changes the name and signature of the method
  that the Ruby Agent wraps for instrumentation. The agent has been updated
  to handle these changes. Users using Sequel 4.35.0 or newer should upgrade
  their agent.

  * Fix DataMapper instrumentation for additional versions

  Different versions of DataMapper have different methods for retrieving the
  adapter name, and Postmodern expanded our coverage. Thanks for the
  contribution!

## v3.16.0 ##

  * Official Rails 5.0 support

  This version of the agent has been verified against the Rails 5.0.0 release.

  * Early access Action Cable instrumentation

  The Ruby agent instruments Action Cable channel actions and calls to
  ActionCable::Channel#Transmit in Rails 5. Feedback is welcome!

  * Obfuscate queries from `oracle_enhanced` adapter correctly

  This change allows the `oracle_enhanced` adapter to use the same
  obfuscation as `oracle` adapters. Thanks Dan Drinkard for the contribution!

  * Make it possible to define a newrelic_role for deployment with Capistrano 3

  Thanks NielsKSchjoedt for the contribution!

  * Retry initial connection to New Relic in Resque master if needed

  Previously, if the initial connection to New Relic in a monitored Resque
  master process failed, the agent would not retry, and monitoring for the
  process would be lost. This has been fixed, and the agent will continue
  retrying in its background harvest thread until it successfully connects.

## v3.15.2 ##

  * Run explain plans on parameterized slow queries in AR4

  In our ActiveRecord 4 instrumentation, we moved to tracing slow queries
  using the payloads from ActiveSupport::Notifications `sql.active_record`
  events. As a result, we were unable to run explain plans on parameterized
  queries. This has now been updated to pass along and use the parameter values,
  when available, to get the explain plans.

  * Fix getMore metric grouping issue in Mongo 2.2.x instrumentation

  A metric grouping issue had cropped up when using the most recent Mongo gem
  (2.2.0) with the most recent release of the server (3.2.4). We now have a more
  future-proof setup for preventing these.

  * Restore older DataMapper support after password obfuscation fix

  Back in 3.14.3, we released a fix to avoid inadvertently sending sensitive
  information from DataMapper SQLErrors. Our implementation did not account for
  DataMapper versions below v0.10.0 not implementing the #options accessor.
  Thanks Bram de Vries for the fix to our fix!

  * Padrino 0.13.1 Support

  Users with Padrino 0.13.x apps were previously seeing the default transaction
  name "(unknown)" for all of their routes. We now provide the full Padrino
  route template in transaction names, including any parameter placeholders.
  Thanks Robert Schulze for the contribution!

  * Update transaction naming for Grape 0.16.x

  In Grape 0.16.x, `route_` methods are no longer prefixed. Thanks to Daniel
  Doubrovkine for the contribution!

  * Fix name collision on method created for default metric name fix

  We had a name collision with the yard gem, which sets a `class_name` method
  on Module. We've renamed our internal method to `derived_class_name` instead.

## v3.15.1 ##

  * Rack 2 alpha support

  This release includes experimental support for Rack 2 as of 2.0.0.alpha.
  Rack 2 is still in development, but the agent should work as expected for
  those who are experimenting with Rack 2.

  * Rails 5 beta 3 support

  We've tweaked our Action View instrumentation to accommodate changes introduced
  in Rails v5.0.0.beta3.

  * Defer referencing ::ActiveRecord::Base to avoid triggering its autoloading
  too soon

  In 3.12.1 and later versions of the agent, the agent references (and
  therefore loads) ActiveRecord::Base earlier on in the Rails loading process.
  This could jump ahead of initializers that should be run first. We now wait
  until ActiveRecord::Base is loaded elsewhere.

  * Fix explain plans for non-parameterized queries with single quote literals

  The agent does not run explain plans for queries still containing parameters
  (such as `SELECT * FROM UNICORNS WHERE ID = $1 LIMIT 1`). This check was
  unfortunately mutating the query to be obfuscated, causing an inability to
  collect an explain plan. This has now been fixed.

  * Fix default metric name for tracing class methods

  When using `add_method_tracer` on a class method but without passing in a
  `metric_name_code`, the default metric name will now look like
  `Custom/ClassName/Class/method_name`. We also addressed default
  metric names for anonymous classes and modules.

  * Fix issue when rendering SQL strings in developer mode

  When we obfuscate SQL statements, we rewrite the Statement objects as
  SQL strings inline in our sample buffers at harvest time. However, in
  developer mode, we also read out of these buffers when rendering pages.
  Depending on whether a harvest has run yet, the buffer will contain either
  Statement objects, SQL strings, or a mix. Now, developer mode can handle
  them all!

  * Fix DelayedJob Sampler reporting incorrect counts in Active Record 3 and below

  When fixing various deprecation warnings on ActiveRecord 4, we introduced
  a regression in our DelayedJob sampler which caused us to incorrectly report
  failed and locked job counts in ActiveRecord 3 and below. This is now fixed.
  Thanks Rangel Dokov for the contribution!

## v3.15.0 ##

  * Rails 5 support

  This release includes experimental support for Rails 5 as of 5.0.0.beta2.
  Please note that this release does not include any support for ActionCable,
  the WebSockets framework new to Rails 5.

  * Don't include extension from single format Grape API transaction names

  Starting with Grape 0.12.0, an API with a single format no longer declares
  methods with `.:format`, but with an extension such as `.json`. Thanks Daniel
  Doubrovkine for the contribution!

  * Fix warnings about shadowing outer local variable when running tests

  Thanks Rafael Almeida de Carvalho for the contribution!

  * Check config first for Rails middleware instrumentation installation

  Checking the config first avoids issues with mock classes that don't implement
  `VERSION`. Thanks Jesse Sanford for the contribution!

  * Remove a trailing whitespace in the template for generated newrelic.yml

  Thanks Paul Menzel for the contribution!

  * Reference external resources in comments and readme with HTTPS

  Thanks Benjamin Quorning for the contribution!

## v3.14.3 ##

  * Don't inadvertently send sensitive information from DataMapper SQLErrors

  DataObjects::SQLError captures the SQL query, and when using versions of
  data_objects prior to 0.10.8, built a URI attribute that contained the
  database connection password. The :query attribute now respects the obfuscation
  level set for slow SQL traces and splices out any password parameters to the
  URI when sending up traced errors to New Relic.

  * Improved SQL obfuscation algorithm

  To help standardize SQL obfuscation across New Relic language agents, we've
  improved the algorithm used and added more test cases.

  * Configurable longer sql_id attribute on slow SQL traces

  The sql_id attribute on slow SQL traces is used to aggregate normalized
  queries together. Previously, these IDs would generally be 9-10 digits long,
  due to a backend restriction. If `slow_sql.use_longer_sql_id` is set to `true`,
  these IDs will now be 18-19 digits long.

## v3.14.2 ##

  * Improved transaction names for Sinatra

  The agent will now use sinatra.route for transaction names on Sinatra 1.4.3+,
  which sets it in the request environment. This gives names that closer resemble the
  routes defined in the Sinatra DSL.  Thanks to Brian Phillips for the suggestion!

  * Bugfix for error flag on transaction events

  There was an issue causing the error flag to always be set to false for Insights
  transaction events that has been fixed.

  * Official support for Sidekiq 4

  The Ruby agent now officially supports Sidekiq 4.

  * Additional attributes collected

  The agent now collects the following information in web transactions:
  Content-Length HTTP response and Content-Type HTTP request headers.

## v3.14.1 ##

  * Add support for setting a display name on hosts

  You can now configure a display name for your hosts using process_host.display_name,
  to more easily distinguish dynamically assigned hosts. For more info, see
  https://docs.newrelic.com/docs/apm/new-relic-apm/maintenance/add-rename-remove-hosts#display_name

  * Fixes automatic middleware instrumentation for Puma 2.12.x

  Starting with version 2.12.x the Puma project inlines versions of Rack::Builder
  and Rack::URLMap under the Puma namespace. This had the unfortunate side effect of
  breaking automatic Rack middleware instrumentation. We now instrument Puma::Rack::Builder
  and Puma::Rack::URLMap and once again have automatic Rack middleware instrumentation for
  applications running on Puma.

  * Do not use a DelayedJob's display_name for naming the transaction

  A DelayedJob's name may be superceded by a display_name, which can
  lead to a metric grouping issue if the display_name contains unique
  identifiers. We no longer use job name methods that may lead to an
  arbitrary display_name. Instead, we use the appropriate class and/or
  method names, depending what makes sense for the job and how it's called.

  * Improvements to Mongo 2.1.x instrumentation

  Fixes issue where getMore operations in batched queries could create metric grouping issues.
  Previously when multiple Mongo queries executed in the same scope only a single query was recorded
  as part of a transaction trace. Now transaction trace nodes will be created for every query
  executed during a transaction.

  * Bugfix for NewRelic::Agent.notice_error

  Fixes issue introduced in v3.14.0 where calling NewRelic::Agent.notice_error outside of an active
  transaction results in a NoMethodError.

  * Bugfix for Resque TransactionError events

  Fixes error preventing Transaction Error events generated in Resque tasks from being sent to New Relic.

## v3.14.0 ##

  * pruby marshaller removed

  The deprecated pruby marshaller has now been removed; the `marshaller` config
  option now only accepts `json`. Customers still running Ruby 1.8.7/REE must
  add the `json` gem to their Gemfile, or (preferably) upgrade to Ruby 1.9.3 or
  newer.

  * Log dates in ISO 8601 format

  The agent will now log dates in ISO 8601 (YYYY-mm-dd) format, instead of
  mm/dd/yy.

  * Additional attributes collected

  The agent now collects the following information in web transactions:
  Accept, Host, User-Agent, Content-Length HTTP request headers, HTTP request
  method, and Content-Type HTTP response header.

  * TransactionErrors reported for Advanced Analytics for APM Errors

  With this release, the agent reports TransactionError events. These new events
  power the beta feature Advanced Analytics for APM Errors. The error events are
  also available today through New Relic Insights.

  Advanced Analytics for APM Errors lets you see all of your errors, with
  granular detail. Filter and group by any attribute to analyze them. Take
  action to resolve issues through collaboration.

  For more information, see https://docs.newrelic.com/docs/apm/applications-menu/events/view-apm-errors-error-traces

## v3.13.2 ##

  * Don't fail to send data when using 'mathn' library

  Version 3.12.1 introduced a bug with applications using the 'mathn' library
  that would prevent the agent from sending data to New Relic. This has been
  fixed.

## v3.13.1 ##

  * Don't use a pager when running `git log` command

  This would cause Capistrano deploys to hang when a large number of commits were being deployed.
  Thanks to John Naegle for reporting and fixing this issue!

  * Official support for JRuby 9.0.0.0

  The Ruby agent is now officially fully tested and supported on JRuby 9.0.0.0.

  * Instrumentation for MongoDB 2.1.x

  Visibility in your MongoDB queries returns when using version 2.1.0 of
  the Mongo driver or newer.  Thanks to Durran Jordan of MongoDB for contributing
  the Mongo Monitoring instrumentation!

  * Fix for ArgumentError "invalid byte sequence in UTF-8"

  This would come up when trying to parse out the operation from a database query
  containing characters that would trigger a invalid byte sequence in UTF-8 error.
  Thanks to Mario Izquierdo for reporting this issue!

  * Improved database metric names for ActiveRecord::Calculations queries

  Aggregate metrics recorded for queries made via the ActiveRecord::Calculations
  module (#count, #sum, #max, etc.) will now be associated with the correct
  model name, rather than being counted as generic 'select' operations.

  * Allow at_exit handlers to be installed for Rubinius

  Rubinius can support the at_exit block used by install_exit_handler.
  Thanks to Aidan Coyle for reporting and fixing this issue!

## v3.13.0 ##

  * Bugfix for uninitialized constant NewRelic::Agent::ParameterFiltering

  Users in some environments encountered a NameError: uninitialized constant
  NewRelic::Agent::ParameterFiltering from the Rails instrumentation while
  running v3.12.x of the Ruby agent. This issue has been fixed.

  * Rake task instrumentation

  The Ruby agent now provides opt-in tracing for Rake tasks. If you run
  long jobs via Rake, you can get all the visibility and goodness of New Relic
  that your other background jobs have. To enable this, see
  https://docs.newrelic.com/docs/agents/ruby-agent/frameworks/rake

  * Redis instrumentation

  Redis operations will now show up on the Databases tab and in transaction
  traces. By default, only command names will be captured; to capture command
  arguments, set `transaction_tracer.record_redis_arguments` to `true` in
  your configuration.

  * Fix for over-obfuscated SQL Traces and PostgreSQL

  An issue with the agent obfuscating column and table names from Slow SQL
  Traces when using PostgreSQL has been resolved.

  * Rubinius 2.5.8 VM metric renaming support

  Rubinius 2.5.8 changed some VM metric names and eliminated support for
  total allocated object counters. The agent has been updated accordingly.

  * Fix agent attributes with a value of false not being stored

  An issue introduced in v3.12.1 prevented attributes (like those added with
  `add_custom_attributes`) from being stored if their value was false. This has
  been fixed.

## v3.12.1 ##

  * More granular Database metrics for ActiveRecord 3 and 4

  Database metrics recorded for non-SELECT operations (UPDATE, INSERT, DELETE,
  etc.) on ActiveRecord 3 and 4 now include the model name that the query was
  being executed against, allowing you to view these queries broken down by
  model on the Datastores page. Thanks to Bill Kayser for reporting this issue!

  * Support for Multiverse testing third party gems

  The Ruby agent has rich support for testing multiple gem versions, but
  previously that wasn't accessible to third party gems.  Now you can now
  simply `require 'task/multiverse'` in your Rakefile to access the same
  test:multiverse task that New Relic uses itself. For more details, see:

  https://docs.newrelic.com/docs/agents/ruby-agent/frameworks/third-party-instrumentation#testing-your-extension

  * Use Sidekiq 3.x's error handler

  Sidekiq 3.x+ provides an error handler for internal and middleware related
  failures. Failures at these points were previously unseen by the Ruby agent,
  but now they are properly traced.

  * Better error messages for common configuration problems with Capistrano

  Templating errors in newrelic.yml would result in obscure error messages
  during Capistrano deployments. These messages now more properly reflect the
  root cause of the errors.

  * newrelic_ignore methods allow strings

  The newrelic_ignore methods previously only supported passing symbols, and
  would quietly ignore any strings passed. Now strings can be passed as well
  to get the intuitive ignoring behavior you'd expect.

  * Replace DNS resolver for Resque jobs with Resolv

  In some circumstances customers with a very high number of short-lived Resque
  jobs were experiencing deadlocks during DNS resolution. Resolv is an all Ruby
  DNS resolver that replaces the libc implementation to prevent these deadlocks.

## v3.12.0 ##

  * Flexible capturing of attributes

  The Ruby agent now allows you more control over exactly which request
  parameters and job arguments are attached to transaction traces, traced
  errors, and Insights events. For details, see:

  https://docs.newrelic.com/docs/agents/ruby-agent/ruby-agent-attributes

  * Fixed missing URIs in traces for retried Excon requests

  If Excon's idempotent option retried a request, the transaction trace node
  for the call would miss having the URI assigned. This has been fixed.

  * Capturing request parameters from rescued exceptions in Grape

  If an exception was handled via a rescue_from in Grape, request parameters
  were not properly set on the error trace. This has been fixed. Thanks to
  Ankit Shah for helping us spot the bug.

## v3.11.2 ##

  * Better naming for Rack::URLMap

  If a Rack app made direct use of Rack::URLMap, instrumentation would miss
  out on using the clearest naming based on the app class. This has been
  fixed.

  * Avoid performance regression in makara database adapter

  Delegation in the makara database adapter caused performance issues when the
  agent looked up a connection in the pool.  The agent now uses a faster
  lookup to work around this problem in makara, and allocates less as well.
  Thanks Mike Nelson for the help in resolving this!

  * Allow audit logging to STDOUT

  Previously audit logs of the agent's communication with New Relic could only
  write to a file. This prevented using the feature on cloud providers like
  Heroku. Now STDOUT is an allowed destination for `audit_log.path`. Logging
  can also be restricted to certain endpoints via `audit_log.endpoints`.

  For more information see https://docs.newrelic.com/docs/agents/ruby-agent/installation-configuration/ruby-agent-configuration#audit_log

  * Fix for crash during startup when Rails required but not used

  If an application requires Rails but wasn't actually running it, the Ruby
  agent would fail during startup. This has been fixed.

  * Use IO.select explicitly in the event loop

  If an application adds their own select method to Object/Kernel or mixes in a
  module that overrides the select method (as with ActionView::Helpers) we would
  previously have used their implementation instead of the intended IO.select,
  leading to all sorts of unusual errors. We now explicitly reference IO.select
  in the event loop to avoid these issues.

  * Fix for background thread hangs on old Linux kernels

  When running under Ruby 1.8.7 on Linux kernel versions 2.6.11 and earlier,
  the background thread used by the agent to report data would hang, leading
  to no data being reported. This has been be fixed.

## v3.11.1 ##

  If an application adds their own select method to Object/Kernel or mixes in a
  module that overrides the select method (as with ActionView::Helpers) we would
  previously have used their implementation instead of the intended IO.select,
  leading to all sorts of unusual errors. We now explicitly reference IO.select
  in the event loop to avoid these issues.

  * Fix for background thread hangs on old Linux kernels

  When running under Ruby 1.8.7 on Linux kernel versions 2.6.11 and earlier,
  the background thread used by the agent to report data would hang, leading
  to no data being reported. This has been be fixed.

## v3.11.1 ##

  The Ruby agent incorrectly rescued exceptions at a point which caused
  sequel_pg 1.6.11 to segfault. This has been fixed. Thanks to Oldrich
  Vetesnik for the report!

## v3.11.0 ##

  * Unified view for SQL database and NoSQL datastore products.

  The response time charts in the application overview page will now include
  NoSQL datastores, such as MongoDB, and also the product name of existing SQL
  databases such as MySQL, Postgres, etc.

  The Databases page will now enable the filtering of metrics and operations
  by product, and includes a table listing all operations.

  For existing SQL databases, in addition to the existing breakdown of SQL
  statements and operations, the queries are now also associated with the
  database product being used.

  For NoSQL datastores, such as MongoDB, we have now added information about
  operations performed against those products, similar to what is being done
  for SQL databases.

  Because this introduces a notable change to how SQL database metrics are
  collected, it is important that you upgrade the agent version on all hosts.
  If you are unable to transition to the latest agent version on all hosts at
  the same time, you can still access old and new metric data for SQL
  databases, but the information will be split across two separate views.

  For more information see https://docs.newrelic.com/docs/apm/applications-menu/monitoring/databases-slow-queries-dashboard

  * Track background transactions as Key Transactions

  In prior versions of the Ruby agent, only web transactions could be tracked
  as Key Transactions. This functionality is now available to all
  transactions, including custom Apdex values and X-Ray sessions.

  For more information see https://docs.newrelic.com/docs/apm/selected-transactions/key-transactions/key-transactions-tracking-important-transactions-or-events

  * More support and documentation for third-party extensions

  It's always been possible to write extension gems for the Ruby agent, but
  now there's one location with best practices and recommendations to guide
  you in writing extensions. Check out
  https://docs.newrelic.com/docs/agents/ruby-agent/frameworks/third-party-instrumentation

  We've also added simpler APIs for tracing datastores and testing your
  extensions. It's our way of giving back to everyone who's helped build on
  the agent over the years. <3

  * Fix for anonymous class middleware naming

  Metric names based off anonymous middlewares lacked a class name in the UI.
  The Ruby agent will now look for a superclass, or default to AnonymousClass
  in those cases.

  * Improved exit behavior in the presence of Sinatra

  The agent uses an `at_exit` hook to ensure data from the last < 60s before a
  process exits is sent to New Relic. Previously, this hook was skipped if
  Sinatra::Application was defined. This unfortunately missed data for
  short-lived background processes that required, but didn't run, Sinatra. Now
  the agent only skips its `at_exit` hook if Sinatra actually runs from
  `at_exit`.

## v3.10.0 ##

  * Support for the Grape framework

  We now instrument the Grape REST API framework! To avoid conflicts with the
  third-party newrelic-grape gem, our instrumentation will not be installed if
  newrelic-grape is present in the Gemfile.

  For more details, see https://docs.newrelic.com/docs/agents/ruby-agent/frameworks/grape-instrumentation

  * Automatic Cross Application Tracing support for all Rack applications

  Previously Rack apps not using Rails or Sinatra needed to include the
  AgentHooks middleware to get Cross Application Tracing support. With
  these changes, this is no longer necessary. Any explicit references to
  AgentHooks can be removed unless the `disable_middleware_instrumentation`
  setting is set to `true`.

  * Metrics no longer reported from Puma master processes

  When using Puma's cluster mode with the preload_app! configuration directive,
  the agent will no longer start its reporting thread in the Puma master
  process. This should result in more accurate instance counts, and more
  accurate stats on the Ruby VMs page (since the master process will be
  excluded).

  * Better support for Sinatra apps used with Rack::Cascade

  Previously, using a Sinatra application as part of a Rack::Cascade chain would
  cause all transactions to be named after the Sinatra application, rather than
  allowing downstream applications to set the transaction name when the Sinatra
  application returned a 404 response. This has been fixed.

  * Updated support for Rubinius 2.3+ metrics

  Rubinius 2.3 introduced a new system for gathering metrics from the
  underlying VM. Data capture for the Ruby VM's page has been updated to take
  advantage of these. Thanks Yorick Peterse for the contribution!

  * Fix for missing ActiveJob traced errors

  ActiveJobs processed by backends where the Ruby agent lacked existing
  instrumentation missed reporting traced errors. This did not impact
  ActiveJobs used with Sidekiq or Resque, and has been fixed.

  * Fix possible crash in middleware tracing

  In rare circumstances, a failure in the agent early during tracing of a web
  request could lead to a cascading error when trying to capture the HTTP status
  code of the request. This has been fixed. Thanks to Michal Cichra for the fix!

## v3.9.9 ##

  * Support for Ruby 2.2

  A new version of Ruby is available, and the Ruby agent is ready to run on
  it. We've been testing things out since the early previews so you can
  upgrade to the latest and greatest and use New Relic right away to see how
  the new Ruby's performing for you.

  * Support for Rails 4.2 and ActiveJob

  Not only is a new Ruby available, but a new Rails is out too! The Ruby agent
  provides all the usual support for Rails that you'd expect, and we
  instrument the newly released ActiveJob framework that's part of 4.2.

  * Security fix for handling of error responses from New Relic servers

  This release fixes a potential security issue wherein an attacker who was able
  to impersonate New Relic's servers could have triggered arbitrary code
  execution in agent's host processes by sending a specially-crafted error
  response to a data submission request.

  This issue is mitigated by the fact that the agent uses SSL certificate
  checking in order to verify the identity of the New Relic servers to which it
  connects. SSL is enabled by default by the agent, and can be enforced
  account-wide by enabling High Security Mode for your account:

  https://docs.newrelic.com/docs/accounts-partnerships/accounts/security/high-security

  * Fix for transactions with invalid URIs

  If an application used the agent's `ignore_url_regexes` config setting to
  ignore certain transactions, but received an invalid URI, the agent would
  fail to record the transaction. This has been fixed.

  * Fixed incompatibility with newrelic-grape

  The 3.9.8 release of the Ruby agent included disabled prototyped
  instrumentation for the Grape API framework. This introduced an
  incompatibility with the existing third party extension newrelic-grape. This
  has been fixed. Newrelic-grape continues to be the right solution until
  full agent support for Grape is available.

## v3.9.8 ##

  * Custom Insights events API

  In addition to attaching custom parameters to the events that the Ruby agent
  generates automatically for each transaction, you can now record custom event
  types into Insights with the new NewRelic::Agent.record_custom_event API.

  For details, see https://docs.newrelic.com/docs/insights/new-relic-insights/adding-querying-data/inserting-custom-events-new-relic-agents

  * Reduced memory usage for idling applications

  Idling applications using the agent could previously appear to leak memory
  because of native allocations during creation of new SSL connections to our
  servers. These native allocations didn't factor into triggering Ruby's
  garbage collector.

  The agent will now re-use a single TCP connection to our servers for as long
  as possible, resulting in improved memory usage for applications that are
  idling and not having GC triggered for other reasons.

  * Don't write to stderr during CPU sampling

  The Ruby agent's code for gathering CPU information would write error
  messages to stderr on some FreeBSD systems. This has been fixed.

  * LocalJumpError on Rails 2.x

  Under certain conditions, Rails 2.x controller instrumentation could fail
  with a LocalJumpError when an action was not being traced. This has been
  fixed.

  * Fixed config lookup in warbler packaged apps

  When running a Ruby application from a standalone warbler .jar file on
  JRuby, the packaged config/newrelic.yml was not properly found. This has
  been fixed, and thanks to Bob Beaty for the help getting it fixed!

  * Hash iteration failure in middleware

  If a background thread iterated over the keys in the Rack env hash, it could
  cause failures in New Relic's AgentHooks middleware. This has been fixed.

## v3.9.7 ##

  * Support for New Relic Synthetics

  The Ruby agent now gives you additional information for requests from New
  Relic Synthetics. More transaction traces and events give you a clearer look
  into how your application is performing around the world.

  For more details, see https://docs.newrelic.com/docs/synthetics/new-relic-synthetics/getting-started/new-relic-synthetics

  * Support for multiple job per fork gems with Resque

  The resque-jobs-per-fork and resque-multi-job-forks gems alter Resque to
  fork every N jobs instead of every job. This previously caused issues for
  the Ruby agent, but those have been resolved. These gems are fully supported.

  Running Resque with the FORK_PER_JOB=false environment variable setting is
  also supported now.

  For more details on our Resque support, see https://docs.newrelic.com/docs/agents/ruby-agent/background-jobs/resque-instrumentation

  * Support agent when starting Resque Pool from Rake task

  When running resque-pool with its provided rake tasks, the agent would not
  start up properly. Thanks Tiago Sousa for the fix!

  * Fix for DelayedJob + Rails 4.x queue depth metrics

  The Ruby agent periodically records DelayedJob queuedepth as a metric, but
  this didn't work properly in Rails 4.x applications.  This has been fixed.
  Thanks Jonathan del Strother for his help with the issue!

  * Fix for failure in background transactions with rules.ignore_url_regexes

  The recently added feature for ignoring transactions via URL regexes caused
  errors for non-web transactions. This has been fixed.

  * Rename the TransactionNamer.name method to TransactionNamer.name_for

  The internal TransactionNamer class had a class method called 'name', with a
  different signature than the existing Class#name method and could cause
  problems when trying to introspect instances of the class.

  Thanks to Dennis Taylor for contributing this fix!

## v3.9.6 ##

  * Rails 4.2 ActiveJob support

  A new version of Rails is coming! One of the highlight features is
  ActiveJob, a framework for interacting with background job processors. This
  release of the Ruby agent adds instrumentation to give you insight into
  ActiveJob, whether you're just testing it out or running it for real.

  Metrics are recorded around enqueuing ActiveJobs, and background transactions
  are started for any ActiveJob performed where the agent didn't already
  provide specific instrumentation (such as DelayedJob, Resque and Sidekiq).

  Since Rails 4.2 is still in beta we'd love to hear any feedback on this
  instrumentation so it'll be rock solid for the general release!

  * Ruby 2.2.0-preview1 updates

  Ruby 2.2.0 is on its way later in the year, and the Ruby agent is ready for
  it. Updates to the GC stats and various other small changes have already been
  applied, and our automated tests are running against 2.2.0 so the agent will
  be ready on release day.

  * Ignoring transactions by URL

  While you could always ignore transactions by controller and action, the
  Ruby agent previously lacked a way to ignore by specific URLs or patterns
  without code changes. This release adds the config setting,
  `rules.ignore_url_regexes` to ignore specific transactions based on the
  request URL as well. For more information, see the documentation at:
  https://docs.newrelic.com/docs/agents/ruby-agent/installation-configuration/ignoring-specific-transactions#config-ignoring

  * Better dependency detection in non-Rack applications

  The Ruby agent runs dependency detection at key points in the Rack and Rails
  lifecycle, but non-Rails apps could occasionally miss out instrumenting late
  loaded libraries. The agent now runs an additional dependency detection
  during manual_start to more seamlessly install instrumentation in any app.

  * Excluding /newrelic routes from developer mode

  Recent changes to track time in middleware resulted in New Relic's developer
  mode capturing its own page views in the list. This has been fixed. Thanks
  to Ignatius Reza Lesmana for the report!

  * Spikes in external time

  Timeouts during certain external HTTP requests could result in incorrect
  large spikes in the time recorded by the agent. This has been fixed.

  * Recognize browser_monitoring.auto_instrument setting in non-Rails apps

  The `browser_monitoring.auto_instrument` config setting disables
  auto-injection of JavaScript into your pages, but was not properly obeyed in
  Sinatra and other non-Rails contexts.  This has been fixed.

  * Failures to gather CPU thread time on JRuby

  JRuby running on certain JVM's and operating systems (FreeBSD in particular)
  did not always support the method being used to gather CPU burn metrics.
  This would result in a failure during those transactions. This has been
  fixed.

  * Fix for rare race condition in Resque instrumentation

  A race condition in the agent's Resque instrumentation that could cause rare
  Resque job failures in high-throughput Resque setups has been fixed. This bug
  would manifest as an exception with the following error message:
  "RuntimeError: can't add a new key into hash during iteration" and a backtrace
  leading through the PipeChannelManager class in the agent.

## v3.9.5 ##

  * Per-dyno data on Heroku

  When running on Heroku, data from the agent can now be broken out by dyno
  name, allowing you to more easily see what's happening on a per-dyno level.
  Dynos on Heroku are now treated in the same way that distinct hosts on other
  platforms work.

  By default, 'scheduler' and 'run' dyno names will be aggregated into
  'scheduler.*' and 'run.*' to avoid unbounded growth in the number of reported
  hostnames.

  Read more about this feature on our Heroku docs page:
  https://docs.newrelic.com/docs/agents/ruby-agent/miscellaneous/ruby-agent-heroku

  * HTTP response codes in Insights events

  The Ruby agent will now capture HTTP response codes from Rack applications
  (including Rails and Sinatra apps) and include them under the httpResponseCode
  attribute on events sent to Insights.

  * Stricter limits on memory usage of SQL traces

  The agent now imposes stricter limits on the number of distinct SQL traces
  that it will buffer in memory at any point in time, leading to more
  predictable memory consumption even in exceptional circumstances.

  * Improved reliability of thread profiling

  Several issues that would previously have prevented the successful completion
  and transmission of thread profiles to New Relic's servers have been fixed.

  These issues were related to the use of recursion in processing thread
  profiles, and have been addressed by both limiting the maximum depth of the
  backtraces recorded in thread profiles, and eliminating the agent's use of
  recursion in processing profile data.

  * Allow tracing Rails view helpers with add_method_tracer

  Previously, attempting to trace a Rails view helper method using
  add_method_tracer on the view helper module would lead to a NoMethodError
  when the traced method was called (undefined method `trace_execution_scoped').
  This has been fixed.

  This issue was an instance of the Ruby 'dynamic module inclusion' or 'double
  inclusion' problem. Usage of add_method_tracer now no longer relies upon the
  target class having actually picked up the trace_execution_scoped method from
  the NewRelic::Agent::MethodTracer module.

  * Improved performance of queue time parsing

  The number of objects allocated while parsing the front-end timestamps on
  incoming HTTP requests has been significantly reduced.

  Thanks to Aleksei Magusev for the contribution!

## v3.9.4 ##

  * Allow agent to use alternate certificate stores

  When connecting via SSL to New Relic services, the Ruby agent verifies its
  connection via a certificate bundle shipped with the agent. This had problems
  with certain proxy configurations, so the `ca_bundle_path` setting in
  newrelic.yml can now override where the agent locates the cert bundle to use.

  For more information see the documentation at:
  https://docs.newrelic.com/docs/agents/ruby-agent/installation-configuration/ssl-settings-ruby-agent

  * Rails 4.2 beta in tests

  Although still in beta, a new version of Rails is on its way!  We're
  already running our automated test suites against the beta to ensure New
  Relic is ready the day the next Rails is released.

  * ActiveRecord 4 cached queries fix

  Queries that were hitting in the ActiveRecord 4.x query cache were
  incorrectly being counted as database time by the agent.

  * Fix for error in newrelic.yml loading

  If your application ran with a RAILS_ENV that was not listed in newrelic.yml
  recent agent versions would give a NameError rather than a helpful message.
  This has been fixed. Thanks Oleksiy Kovyrin for the patch!

## v3.9.3 ##

  * Fix to prevent proxy credentials transmission

  This update prevents proxy credentials set in the agent config file from
  being transmitted to New Relic.

## v3.9.2 ##

  * Added API for ignoring transactions

  This release adds three new API calls for ignoring transactions:

    - `NewRelic::Agent.ignore_transaction`
    - `NewRelic::Agent.ignore_apdex`
    - `NewRelic::Agent.ignore_enduser`

  The first of these ignores a transaction completely: nothing about it will be
  reported to New Relic. The second ignores only the Apdex metric for a single
  transaction. The third disables javascript injection for browser monitoring
  for the current transaction.

  These methods differ from the existing newrelic_ignore_* method in that they
  may be called *during* a transaction based on some dynamic runtime criteria,
  as opposed to at the class level on startup.

  See the docs for more details on how to use these methods:
  https://docs.newrelic.com/docs/agents/ruby-agent/installation-and-configuration/ignoring-specific-transactions

  * Improved SQL obfuscation

  SQL queries containing string literals ending in backslash ('\') characters
  would previously not have been obfuscated correctly by the Ruby agent prior to
  transmission to New Relic. In addition, SQL comments were left un-obfuscated.
  This has been fixed, and the test coverage for SQL obfuscation has been
  improved.

  * newrelic_ignore* methods now work when called in a superclass

  The newrelic_ignore* family of methods previously did not apply to subclasses
  of the class from which it was called, meaning that Rails controllers
  inheriting from a single base class where newrelic_ignore had been called
  would not be ignored. This has been fixed.

  * Fix for rare crashes in Rack::Request#params on Sinatra apps

  Certain kinds of malformed HTTP requests could previously have caused
  unhandled exceptions in the Ruby agent's Sinatra instrumentation, in the
  Rack::Request#params method. This has been fixed.

  * Improved handling for rare errors caused by timeouts in Excon requests

  In some rare cases, the agent would emit a warning message in its log file and
  abort instrumentation of a transaction if a timeout occurred during an
  Excon request initiated from within that transaction. This has been fixed.

  * Improved behavior when the agent is misconfigured

  When the agent is misconfigured by attempting to shut it down without
  it ever having been started, or by attempting to disable instrumentation after
  instrumentation has already been installed, the agent will no longer raise an
  exception, but will instead log an error to its log file.

  * Fix for ignore_error_filter not working in some configurations

  The ignore_error_filter method allows you to specify a block to be evaluated
  in order to determine whether a given error should be ignored by the agent.
  If the agent was initially disabled, and then later enabled with a call to
  manual_start, the ignore_error_filter would not work. This has been fixed.

  * Fix for Capistrano 3 ignoring newrelic_revision

  New Relic's Capistrano recipes support passing parameters to control the
  values recorded with deployments, but user provided :newrelic_revision was
  incorrectly overwritten. This has been fixed.

  * Agent errors logged with ruby-prof in production

  If the ruby-prof gem was available in an environment without New Relic's
  developer mode enabled, the agent would generate errors to its log. This has
  been fixed.

  * Tighter requirements on naming for configuration environment variables

  The agent would previously assume any environment variable containing
  'NEWRELIC' was a configuration setting. It now looks for this string as a
  prefix only.

  Thanks to Chad Woolley for the contribution!

## v3.9.1 ##

  * Ruby 1.8.7 users: upgrade or add JSON gem now

  Ruby 1.8.7 is end-of-lifed, and not receiving security updates, so we strongly
  encourage all users with apps on 1.8.7 to upgrade.

  If you're not able to upgrade yet, be aware that a coming release of the Ruby
  agent will require users of Ruby 1.8.7 to have the 'json' gem available within
  their applications in order to continue sending data to New Relic.

  For more details, see:
  https://docs.newrelic.com/docs/ruby/ruby-1.8.7-support

  * Support for new Cross Application Trace view

  This release enhances cross application tracing with a visualization of
  the cross application calls that a specific Transaction Trace is involved
  in. The new visualization helps you spot bottlenecks in external services
  within Transaction Traces and gives you an end-to-end understanding
  of how the transaction trace is used by other applications and services.
  This leads to faster problem diagnosis and better collaboration across
  teams. All agents involved in the cross application communication must
  be upgraded to see the complete graph. You can view cross application
  traces from in the Transaction Trace drill-down.

  * High security mode V2

  The Ruby agent now supports V2 of New Relic's high security mode. To enable
  it, you must add 'high_security: true' to your newrelic.yml file, *and* enable
  high security mode through the New Relic web interface. The local agent
  setting must be in agreement with the server-side setting, or the agent will
  shut down and no data will be collected.

  Customers who already had the server-side high security mode setting enabled
  must add 'high_security: true' to their agent configuration files when
  upgrading to this release.

  For details on high security mode, see:
  http://docs.newrelic.com/docs/accounts-partnerships/accounts/security/high-security

  * Improved memcached instrumentation

  More accurate instrumentation for the 'cas' command when using version 1.8.0
  or later of the memcached gem. Previous versions of the agent would count all
  time spent in the block given to 'cas' as memcache time, but 1.8.0 and later
  allows us to more accurately measure just the time spent talking to memcache.

  Many thanks to Francis Bogsanyi for contributing this change!

  * Improved support for Rails apps launched from outside the app root directory

  The Ruby agent attempts to resolve the location of its configuration file at
  runtime relative to the directory that the host process is started from.

  In cases where the host process was started from outside of the application's
  root directory (for example, if the process is started from from '/'), it will
  now also attempt to locate its configuration file based on the value of
  Rails.root for Rails applications.

  * Better compatibility with ActionController::Live

  Browser Application Monitoring auto-injection can cause request failures under
  certain circumstances when used with ActionController::Live, so the agent will
  now automatically detect usage of ActionController::Live, and not attempt
  auto-injection for those requests (even if auto-instrumentation is otherwise
  enabled).

  Many thanks to Rodrigo Rosenfeld Rosas for help diagnosing this issue!

  * Fix for occasional spikes in external services time

  Certain kinds of failures during HTTP requests made by an application could
  have previously resulted in the Ruby agent reporting erroneously large amounts
  of time spent in outgoing HTTP requests. This issue manifested most obviously
  in spikes on the 'Web external' band on the main overview graph. This issue
  has now been fixed.

  * Fix 'rake newrelic:install' for Rails 4 applications

  The newrelic:install rake task was previously not working for Rails 4
  applications and has been fixed.

  Thanks to Murahashi Sanemat Kenichi for contributing this fix!

## v3.9.0 ##

  * Rack middleware instrumentation

  The Ruby agent now automatically instruments Rack middlewares!

  This means that the agent can now give you a more complete picture of your
  application's response time, including time spent in middleware. It also means
  that requests which previously weren't captured by the agent because they
  never made it to the bottom of your middleware stack (usually a Rails or
  Sinatra application) will now be captured.

  After installing this version of the Ruby agent, you'll see a new 'Middleware'
  band on your application's overview graph, and individual middlewares will
  appear in transaction breakdown charts and transaction traces.

  The agent can instrument middlewares that are added from a config.ru file via
  Rack::Builder, or via Rails' middleware stack in Rails 3.0+.

  This instrumentation may be disabled with the
  disable_middlware_instrumentation configuration setting.

  For more details, see the documentation for this feature:

    - http://docs.newrelic.com/docs/ruby/rack-middlewares
    - http://docs.newrelic.com/docs/ruby/middleware-upgrade-changes

  * Capistrano 3.x support

  Recording application deployments using Capistrano 3.x is now supported.

  Many thanks to Jennifer Page for the contribution!

  * Better support for Sidekiq's Delayed extensions

  Sidekiq jobs executed via the Delayed extensions (e.g. the #delay method) will
  now be named after the actual class that #delay was invoked against, and will
  have their job arguments correctly captured if the sidekiq.capture_params
  configuration setting is enabled.

  Many thanks to printercu for the contribution!

  * Improved Apdex calculation with ignored error classes

  Previously, a transaction resulting in an exception that bubbled up to the top
  level would always be counted as failing for the purposes of Apdex
  calculations (unless the transaction name was ignored entirely). Now,
  exceptions whose classes have been ignored by the
  error_collector.ignore_errors configuration setting will not cause a
  transaction to be automatically counted as failing.

  * Allow URIs that are not parseable by stdlib's URI if addressable is present

  There are some URIs that are valid by RFC 3986, but not parseable by Ruby's
  stdlib URI class. The Ruby agent will now attempt to use the addressable gem
  to parse URIs if it is present, allowing requests against these problematic
  URIs to be instrumented.

  Many thanks to Craig R Webster and Amir Yalon for their help with this issue!

  * More robust error collection from Resque processes

  Previously, traced errors where the exception class was defined in the Resque
  worker but not in the Resque master process would not be correctly handled by
  the agent. This has been fixed.

  * Allow Sinatra apps to set the New Relic environment without setting RACK_ENV

  The NEW_RELIC_ENV environment variable may now be used to specify the
  environment the agent should use from its configuration file, independently of
  RACK_ENV.

  Many thanks to Mario Izquierdo for the contribution!

  * Better error handling in Browser Application Monitoring injection

  The agent middleware that injects the JavaScript code necessary for Browser
  Application Monitoring now does a better job of catching errors that might
  occur during the injection process.

  * Allow disabling of Net::HTTP instrumentation

  Most instrumentation in the Ruby agent can be disabled easily via a
  configuration setting. Our Net::HTTP instrumentation was previously an
  exception, but now it can also be disabled with the disable_net_http
  configuration setting.

  * Make Rails constant presence check more defensive

  The Ruby agent now guards against the (rare) case where an application has a
  Rails constant defined, but no Rails::VERSION constant (because Rails is not
  actually present).

  Many thanks to Vladimir Kiselev for the contribution!

## v3.8.1 ##

  * Better handling for Rack applications implemented as middlewares

  When using a Sinatra application as a middleware around another app (for
  example, a Rails app), or manually instrumenting a Rack middleware wrapped
  around another application, the agent would previously generate two separate
  transaction names in the New Relic UI (one for the middleware, and one for
  the inner application).

  As of this release, the agent will instead unify these two parts into a single
  transaction in the UI. The unified name will be the name assigned to the
  inner-most traced transaction by default. Calls to
  NewRelic::Agent.set_transaction_name will continue to override the default
  names assigned by the agent's instrumentation code.

  This change also makes it possible to run X-Ray sessions against transactions
  of the 'inner' application in cases where one instrumented app is wrapped in
  another that's implemented as a middleware.

  * Support for mongo-1.10.0

  The Ruby agent now instruments version 1.10.0 of the mongo gem (versions 1.8.x
  and 1.9.x were already supported, and continue to be).

  * Allow setting configuration file path via an option to manual_start

  Previously, passing the :config_path option to NewRelic::Agent.manual_start
  would not actually affect the location that the agent would use to look for
  its configuration file. This has been fixed, and the log messages emitted when
  a configuration file is not found should now be more helpful.

## v3.8.0 ##

  * Better support for forking and daemonizing dispatchers (e.g. Puma, Unicorn)

  The agent should now work out-of-the box with no special configuration on
  servers that fork or daemonize themselves (such as Unicorn or Puma in some
  configurations). The agent's background thread will be automatically restarted
  after the first transaction processed within each child process.

  This change means it's no longer necessary to set the
  'restart_thread_in_children setting' in your agent configuration file if you
  were doing so previously.

  * Rails 4.1 support

  Rails 4.1 has shipped, and the Ruby agent is ready for it! We've been running
  our test suites against the release candidates with no significant issues, so
  we're happy to announce full compatibility with this new release of Rails.

  * Ruby VM measurements

  The Ruby agent now records more detailed information about the performance and
  behavior of the Ruby VM, mainly focused around Ruby's garbage collector. This
  information is exposed on the new 'Ruby VM' tab in the UI. For details about
  what is recorded, see:

  http://docs.newrelic.com/docs/ruby/ruby-vm-stats

  * Separate in-transaction GC timings for web and background processes

  Previously, an application with GC instrumentation enabled, and both web and
  background processes reporting in to it would show an overly inflated GC band
  on the application overview graph, because data from both web and non-web
  transactions would be included. This has been fixed, and GC time during web
  and non-web transactions is now tracked separately.

  * More accurate GC measurements on multi-threaded web servers

  The agent could previously have reported inaccurate GC times on multi-threaded
  web servers such as Puma. It will now correctly report GC timings in
  multi-threaded contexts.

  * Improved ActiveMerchant instrumentation

  The agent will now trace the store, unstore, and update methods on
  ActiveMerchant gateways. In addition, a bug preventing ActiveMerchant
  instrumentation from working on Ruby 1.9+ has been fixed.

  Thanks to Troex Nevelin for the contribution!

  * More robust Real User Monitoring script injection with charset meta tags

  Previous versions of the agent with Real User Monitoring enabled could have
  injected JavaScript code into the page above a charset meta tag. By the HTML5
  spec, the charset tag must appear in the first 1024 bytes of the page, so the
  Ruby agent will now attempt to inject RUM script after a charset tag, if one
  is present.

  * More robust connection sequence with New Relic servers

  A rare bug that could cause the agent's initial connection handshake with
  New Relic servers to silently fail has been fixed, and better logging has been
  added to the related code path to ease diagnosis of any future issues.

  * Prevent over-counting of queue time with nested transactions

  When using add_transaction_tracer on methods called from within a Rails or
  Sinatra action, it was previously possible to get inflated queue time
  measurements, because queue time would be recorded for both the outer
  transaction (the Rails or Sinatra action) and the inner transaction (the
  method given to add_transaction_tracer). This has been fixed, so only the
  outermost transaction will now record queue time.

## v3.7.3 ##

  * Obfuscation for PostgreSQL explain plans

  Fixes an agent bug with PostgreSQL where parameters from the original query
  could appear in explain plans sent to New Relic servers, even when SQL
  obfuscation was enabled. Parameters from the query are now masked in explain
  plans prior to transmission when transaction_tracer.record_sql is set to
  'obfuscated' (the default setting).

  For more information, see:
  https://docs.newrelic.com/docs/traces/security-for-postgresql-explain-plans

  * More accurate categorization of SQL statements

  Some SQL SELECT statements that were previously being mis-categorized as
  'SQL - OTHER' will now correctly be tagged as 'SQL - SELECT'. This
  particularly affected ActiveRecord users using PostgreSQL.

  * More reliable Typhoeus instrumentation

  Fixed an issue where an exception raised from a user-specified on_complete
  block would cause our Typhoeus instrumentation to fail to record the request.

  * Fix for Puma 2.8.0 cluster mode (3.7.3.204)

  Puma's 2.8.0 release renamed a hook New Relic used to support Puma's cluster
  mode.  This resulted in missing data for users running Puma. Thanks Benjamin
  Kudria for the fix!

  * Fix for deployment command bug (3.7.3.204)

  Problems with file loading order could result in `newrelic deployments`
  failing with an unrecognized command error. This has been fixed.

## v3.7.2 ##

  * Mongo instrumentation improvements

  Users of the 'mongo' MongoDB client gem will get more detailed instrumentation
  including support for some operations that were not previously captured, and
  separation of aggregate metrics for web transactions from background jobs.

  An issue with ensure_index when passed a symbol or string was also fixed.
  Thanks Maxime RETY for the report!

  * More accurate error tracing in Rails 4

  Traced errors in Rails 4 applications will now be correctly associated with
  the transaction they occurred in, and custom attributes attached to the
  transaction will be correctly attached to the traced error as well.

  * More accurate partial-rendering metrics for Rails 4

  View partials are now correctly treated as sub-components of the containing
  template render in Rails 4 applications, meaning that the app server breakdown
  graphs for Rails 4 transactions should be more accurate and useful.

  * Improved Unicorn 4.8.0 compatibility

  A rare issue that could lead to spurious traced errors on app startup for
  applications using Unicorn 4.8.0 has been fixed.

  * meta_request gem compatibility

  An incompatibility with the meta_request gem has been fixed.

  * Typhoeus 0.6.4+ compatibility

  A potential crash with Typhoeus 0.6.4+ when passing a URI object instead of a
  String instance to one of Typhoeus's HTTP request methods has been fixed.

  * Sequel single threaded mode fix

  The agent will no longer attempt to run EXPLAIN queries for slow SQL
  statements issued using the Sequel gem in single-threaded mode, since
  doing so could potentially cause crashes.

  * Additional functionality for add_custom_parameters

  Calling add_custom_parameters adds parameters to the system codenamed
  Rubicon. For more information, see http://newrelic.com/software-analytics

  * Update gem signing cert (3.7.2.195)

  The certificate used to sign newrelic_rpm expired in February. This patch
  updates that for clients installing with verification.

## v3.7.1 ##

  * MongoDB support

  The Ruby agent provides support for the mongo gem, versions 1.8 and 1.9!
  Mongo calls are captured for transaction traces along with their parameters,
  and time spent in Mongo shows up on the Database tab.

  Support for more Mongo gems and more UI goodness will be coming, so watch
  http://docs.newrelic.com/docs/ruby/mongo for up-to-date status.

  * Harvest thread restarts for forked and daemonized processes

  Historically framework specific code was necessary for the Ruby agent to
  successfully report data after an app forked or daemonized. Gems or scripts
  with daemonizing modes had to wait for agent support or find workarounds.

  With 3.7.1 setting `restart_thread_in_children: true` in your newrelic.yml
  automatically restarts the agent in child processes without requiring custom
  code. For now the feature is opt-in, but future releases may default it on.

  * Fix for missing HTTP time

  The agent previously did not include connection establishment time for
  outgoing Net::HTTP requests. This has been corrected, and reported HTTP
  timings should now be more accurate.

  * Fix for Mongo ensure_index instrumentation (3.7.1.182)

  The Mongo instrumentation for ensure_index in 3.7.1.180 was not properly
  calling through to the uninstrumented version of this method. This has been
  fixed in 3.7.1.182. Thanks to Yuki Miyauchi for the fix!

  * Correct first reported metric timespan for forking dispatchers (3.7.1.188)

  The first time a newly-forked process (in some configurations) reported metric
  data, it would use the startup time of the parent process as the start time
  for that metric data instead of its own start time. This has been fixed.

## v3.7.0 ##

  * Official Rubinius support (for Rubinius >= 2.2.1)

  We're happy to say that all known issues with the Ruby agent running on
  Rubinius have been resolved as of Rubinius version 2.2.1! See
  http://docs.newrelic.com/docs/ruby/rubinius for the most up-to-date status.

  * RUM injection updates

  The Ruby agent's code for both automatic and manual injection of Real User
  Monitoring scripts has been improved. No application changes are required, but
  the new injection logic is simpler, faster, more robust, and paves the way for
  future improvements to Real User Monitoring.

  * More robust communication with New Relic

  Failures when transmitting data to New Relic could cause data to be held over
  unnecessarily to a later harvest. This has been improved both to handle
  errors more robustly and consistently, and to send data as soon as possible.

  * Fix for agent not restarting on server-side config changes

  A bug in 3.6.9 caused the agent to not reset correctly after server-side
  config changes. New settings would not be received without a full process
  restart. This has been fixed.

  * Blacklisting rake spec tasks

  A blacklist helps the agent avoid starting during rake tasks. Some default
  RSpec tasks were missing. Thanks for the contribution Kohei Hasegawa!

## v3.6.9 ##

  * Experimental Rubinius 2.x support

  The agent is now being tested against the latest version of Rubinius. While
  support is still considered experimental, you can track the progress at
  http://docs.newrelic.com/docs/ruby/rubinius for up to date status.

  * Capture arguments for Resque and Sidekiq jobs

  The agent can optionally record arguments for your Resque and Sidekiq jobs on
  transaction traces and traced errors. This is disabled by default, but may be
  enabled by setting resque.capture_params or sidekiq.capture_params.

  Thanks to Juan Ignacio Pumarino, Ken Mayer, Paul Henry, and Eric Saxby for
  their help with this feature!

  * Supported versions rake task and documentation

  We've improved our documentation for what Ruby and gem versions we support.
  Run `rake newrelic:supported_versions` or see the latest agent's versions at
  https://docs.newrelic.com/docs/ruby/supported-frameworks.

  * ActiveRecord 4.0 explain plans for JRuby and Rubinius

  The agent's ActiveRecord 4.0 instrumentation could not gather SQL explain
  plans on JRuby by default because of a dependency on ObjectSpace, which isn't
  avialable by default. This has been fixed.

  * Fix for Curb http_put_with_newrelic

  A bug in the agent caused PUT calls in the Curb gem to crash. This has been
  fixed. Thanks to Michael D'Auria and Kirk Diggler for the contributions!

  * Fix for head position on RUM injection

  Certain unusual HTML documents resulted in browser monitoring injecting
  incorrect content. Thanks Alex McHale for the contribution!

  * Specify the Content-Type header in developer mode

  Thanks Jared Ning for the contribution!

## v3.6.8 ##

  * X-Ray Sessions support

  X-Ray Sessions provide more targeted transaction trace samples and thread
  profiling for web transactions. For full details see our X-Ray sessions
  documentation at https://newrelic.com/docs/site/xray-sessions.

  * Percentiles and Histograms

  The Ruby Agent now captures data that provides percentile and histogram views
  in the New Relic UI.

  * CPU metrics re-enabled for JRuby >= 1.7.0

  To work around a JRuby bug, the Ruby agent stopped gathering CPU metrics on
  that platform.  With the bug fixed, the agent can gather those metrics again.
  Thanks Bram de Vries for the contribution!

  * Missing Resque transaction traces (3.6.8.168)

  A bug in 3.6.8.164 prevented transaction traces in Resque jobs from being
  communicated back to New Relic. 3.6.8.168 fixes this.

  * Retry on initial connect (3.6.8.168)

  Failure to contact New Relic on agent start-up would not properly retry. This
  has been fixed.

  * Fix potential memory leak on failure to send to New Relic (3.6.8.168)

  3.6.8.164 introduced a potential memory leak when transmission of some kinds
  of data to New Relic servers failed. 3.6.8.168 fixes this.

## v3.6.7 ##

  * Resque-pool support

  Resque processes started via the resque-pool gem weren't recognized by the
  Ruby agent. The agent now starts correctly in those worker processes.

  * Environment-based configuration

  All settings in newrelic.yml can now be configured via environment variables.
  See https://newrelic.com/docs/ruby/ruby-agent-configuration for full details.

  * Additional locking option for Resque (3.6.7.159)

  There have been reports of worker process deadlocks in Resque when using the
  Ruby agent. An optional lock is now available to avoid those deadlocks. See
  https://newrelic.com/docs/ruby/resque-instrumentation for more details.

  * HTTP connection setup timeout (3.6.7.159)

  HTTP initialization in the agent lacked an appropriate timeout,
  leading to dropouts in reporting under certain network error conditions.

  * Unnecessary requests from Resque jobs (3.6.7.159)

  An issue causing Resque jobs to unnecessarily make requests against New Relic
  servers was fixed.

  * Fix compatibility issues with excon and curb instrumentation

  This release of the agent fixes a warning seen under certain circumstances
  with the excon gem (most notably, when excon was used by fog), as well as
  a bug with the curb instrumentation that conflicted with the  feedzirra gem.

  * Allow license key to be set by Capistrano variables

  A license key can be passed via a Capistrano variable where previously it
  could only be in newrelic.yml. Thanks Chris Marshall for the contribution!

  * Make HTTP client instrumentation aware of "Host" request header

  If a "Host" header is set explicitly on an HTTP request, that hostname will
  be used for external metrics. Thanks Mislav Marohni?? for the contribution!

  * Fix ActiveSupport::Concern warnings with MethodTracer

  Including NewRelic::Agent::MethodTracer in a class using Concerns could cause
  deprecation warnings. Thanks Mike Po??tyn for the contribution!

  * Fix Authlogic constant name

  Code checking for the Authlogic module was using in the wrong case. Thanks
  Dharam Gollapudi for the contribution!

## v3.6.6 ##

  * HTTPClient and Curb support

  The Ruby agent now supports the HTTPClient and Curb HTTP libraries! Cross
  application tracing and more is fully supported for these libraries. For more
  details see https://newrelic.com/docs/ruby/ruby-http-clients.

  * Sinatra startup improvements

  In earlier agent versions, newrelic_rpm had to be required after Sinatra to
  get instrumentation. Now the agent should start when your Sinatra app starts
  up in rackup, thin, unicorn, or similar web servers.

  * Puma clustered mode support

  Clustered mode in Puma was not reporting data without manually adding a hook
  to Puma's configuration. The agent will now automatically add this hook.

  * SSL certificate verification

  Early versions of the agent's SSL support provided an option to skip
  certificate verification. This option has been removed.

## v3.6.5 ##

  * Rails 4.0 Support

  The Ruby agent is all set for the recent general release of Rails 4.0! We've
  been tracking the RC's, and that work paid off. Versions 3.6.5 and 3.6.4 of
  the Ruby agent should work fine with Rails 4.0.0.

  * Excon and Typhoeus support

  The Ruby agent now supports the Excon and Typhoeus HTTP libraries! For more
  details see https://newrelic.com/docs/ruby/ruby-http-clients.

## v3.6.4 ##

  * Exception Whitelist

  We've improved exception message handling for applications running in
  high security mode. Enabling 'high_security' now removes exception messages
  entirely rather than simply obfuscating any SQL.

  By default this feature affects all exceptions, though you can configure a
  whitelist of exceptions whose messages should be left intact.

  More details: https://newrelic.com/docs/ruby/ruby-agent-configuration

  * Fix a race condition affecting some Rails applications at startup

  Some Rails applications using newrelic_rpm were affected by a race condition
  at startup that manifested as an error when model classes with associations
  were first loaded. The cause of these errors has been addressed by moving the
  generation of the agent's EnvironmentReport on startup from a background
  thread to the main thread.

## v3.6.3 ##

  * Better Sinatra Support

  A number of improvements have been made to our Sinatra instrumentation.
  More details: https://newrelic.com/docs/ruby/sinatra-support-in-the-ruby-agent

  Sinatra instrumentation has been updated to more accurately reflect the final
  route that was actually executed, taking pass and conditions into account.

  New Relic middlewares for error collection, real user monitoring, and cross
  application tracing are automatically inserted into the middleware stack.

  Ignoring routes, similar to functionality available to Rails controllers, is
  now available in Sinatra as well.

  Routes in 1.4 are properly formatting in transaction names. Thanks Zachary
  Anker for the contribution!

  * Padrino Support

  Along with improving our support of Sinatra, we've also extended that to
  supporting Padrino, a framework that builds on Sinatra. Web transactions
  should show up in New Relic now for Padrino apps automatically. The agent has
  been tested against the latest Padrino in versions 0.11.x and 0.10.x.

  * Main overview graph only shows web transactions

  In the past database times from background jobs mixed with other web transaction
  metrics in the main overview graph. This often skewed graphs. A common workaround
  was to send background jobs to a separate application, but that should no longer
  be necessary as the overview graphs now only represent web transactions.

## v3.6.2 ##

  * Sequel support

  The Ruby agent now supports Sequel, a database toolkit for Ruby. This
  includes capturing SQL calls and model operations in transaction traces, and
  recording slow SQL calls. See https://newrelic.com/docs/ruby/sequel-instrumentation
  for full details.

  * Thread profiling fix

  The prior release of the agent (version 3.6.1) broke thread profiling. A
  profile would appear to run, but return no data. This has been fixed.

  * Fix for over-counted Net::HTTP calls

  Under some circumstances, calls into Net::HTTP were being counted twice in
  metrics and transaction traces. This has been fixed.

  * Missing traced errors for Resque applications

  Traced errors weren't displaying for some Resque workers, although the errors
  were factored into the overall count graphs. This has been fixed, and traced
  errors should be available again after upgrading the agent.

## v3.6.1 ##

  * Full URIs for HTTP requests are recorded in transaction traces

  When recording a transaction trace node for an outgoing HTTP call via
  Net::HTTP, the agent will now save the full URI (instead of just the hostname)
  for the request. Embedded credentials, the query string, and the fragment will
  be stripped from the URI before it is saved.

  * Simplify Agent Autostart Logic

  Previously the agent would only start when it detected a supported
  "Dispatcher", meaning a known web server or background task framework.  This
  was problematic for customers using webservers that the agent was not
  configured to detect (e.g. Puma).  Now the agent will attempt to report any
  time it detects it is running in a monitored environment (e.g. production).
  There are two exceptions to this.  The agent will not autostart in a rails
  console or irb session or when the process was invoked by a rake task (e.g.
  rake assets:precompile).  The NEWRELIC_ENABLE environment variable can be set
  to true or false to force the agent to start or not start.

  * Don't attempt to resolve collector hostname when proxy is in use

  When a proxy is configured, the agent will not attempt to lookup and cache the
  IP address of New Relic server to which it is sending data, since DNS may not
  be available in some environments. Thanks to Bill Kirtley for the contribution

  * Added NewRelic::Agent.set_transaction_name and NewRelic::Agent.get_transaction_name

  Ordinarily the name of your transaction is defined up-front, but if you'd like to
  change the name of a transaction while it is still running you can use
  **NewRelic::Agent.set_transaction_name()**.  Similarly, if you need to know the name
  of the currently running transaction, you can use **NewRelic::Agent.get_transaction_name()**.

## v3.6.0 ##

  * Sidekiq support

  The Ruby agent now supports the Sidekiq background job framework. Traces from
  Sidekiq jobs will automatically show up in the Background tasks on New Relic
  similar to Resque and Delayed::Job tasks.

  * Improved thread safety

  The primary metrics data structures in the Ruby agent are now thread safe.
  This should provide better reliability for the agent under JRuby and threaded
  scenarios such as Sidekiq or Puma.

  * More robust environment report

  The agent's analysis of the local environment (e.g. OS, Processors, loaded
  gems) will now work in a wider variety of app environments, including
  Sinatra.

  * Experimental Rainbows! support

  The Ruby agent now automatically detects and instruments the Rainbows! web
  server. This support is considered experimental at present, and has not been
  tested with all dispatch modes.

  Thanks to Joseph Chen for the contribution.

  * Fix a potential file descriptor leak in Resque instrumentation

  A file descriptor leak that occurred when DontPerform exceptions were used to
  abort processing of a job has been fixed. This should allow the Resque
  instrumentation work correctly with the resque-lonely_job gem.

## v3.5.8 ##

  * Key Transactions

    The Ruby agent now supports Key Transactions! Check out more details on the
    feature at https://newrelic.com/docs/site/key-transactions

  * Ruby 2.0

    The Ruby agent is compatible with Ruby 2.0.0 which was just released.

  * Improved Sinatra instrumentation

    Several cases around the use of conditions and pass in Sinatra are now
    better supported by the Ruby agent. Thanks Konstantin for the help!

  * Outbound HTTP headers

    Adds a 'X-NewRelic-ID' header to outbound Net::HTTP requests. This change
    helps improve the correlation of performance between services in a service-
    oriented architecture for a forthcoming feature. In the meantime, to disable
    the header, set this in your newrelic.yml:

      cross_application_tracer:
        enabled: false

  * Automatically detect Resque dispatcher

    The agent does better auto-detection for the Resque worker process.
    This should reduce the need to set NEW_RELIC_DISPATCHER=resque directly.

## v3.5.7 ##

  * Resolved some issues with tracking of frontend queue time, particularly
    when the agent is running on an app hosted on Heroku.  The agent will now
    more reliably parse the headers described in
    https://newrelic.com/docs/features/tracking-front-end-time and will
    automatically detect whether the times provided are in seconds,
    milliseconds or microseconds.

## v3.5.6 ##

  * Use HTTPS by default

    The agent now defaults to using SSL when it communicates with New Relic's
    servers.  By default is already configured New Relic does not transmit any
    sensitive information (e.g. SQL parameters are masked), but SSL adds an
    additional layer of security.  Upgrading customers may need to remove the
    "ssl: false" directive from their newrelic.yml to enable ssl.  Customers on
    Jruby may need to install the jruby-openssl gem to take advantage of this
    feature.

  * Fix two Resque-related issues

    Fixes a possible hang on exit of an instrumented Resque master process
    (https://github.com/defunkt/resque/issues/578), as well as a file descriptor
    leak that could occur during startup of the Resque master process.

  * Fix for error graph over 100%

    Some errors were double counted toward the overall error total. This
    resulted in graphs with error percentages over 100%. This duplication did
    not impact the specific error traces captured, only the total metric.

  * Notice gracefully handled errors in Sinatra

    When show_exceptions was set to false in Sinatra, errors weren't caught
    by New Relic's error collector. Now handled errors also have the chance
    to get reported back.

  * Ruby 2.0 compatibility fixes

    Ruby 2.0 no longer finds protected methods by default, but will with a flag.
    http://tenderlovemaking.com/2012/09/07/protected-methods-and-ruby-2-0.html

    Thanks Ravil Bayramgalin and Charlie Somerville for the fixes.

  * Auto-detect Trinidad as dispatcher

    Code already existing for detecting Trinidad as a dispatcher, but was only
    accessible via an ENV variable. This now auto-detects on startup. Thanks
    Robert Rasmussen for catching that.

  * Coercion of types in collector communication

    Certain metrics can be recorded with a Ruby Rational type, which JSON
    serializes as a string rather than a floating point value. We now treat
    coerce each outgoing value, and log issues before sending the data.

  * Developer mode fix for chart error

    Added require to fix a NameError in developer mode for summary page. Thanks
    to Ryan B. Harvey.

  * Don't touch deprecated RAILS_ROOT if on Rails 3

    Under some odd startup conditions, we would look for the RAILS_ROOT constant
    after failing to find the ::Rails.root in a Rails 3 app, causing deprecation
    warnings. Thanks for Adrian Irving-Beer for the fix.

## v3.5.5 ##

  * Add thread profiling support

    Thread profiling performs statistical sampling of backtraces of all threads
    within your Ruby processes. This feature requires MRI >= 1.9.2, and is
    controlled via the New Relic web UI. JRuby support (in 1.9.x compat mode) is
    considered experimental, due to issues with JRuby's Thread#backtrace.

  * Add audit logging capability

    The agent can now log all of the data it sends to the New Relic servers to
    a special log file for human inspection. This feature is off by default, and
    can be enabled by setting the audit_log.enabled configuration key to true.
    You may also control the location of the audit log with the audit_log.path key.

  * Use config system for dispatcher, framework, and config file detection

    Several aspects of the agent's configuration were not being handled by the
    configuration system.  Detection/configuration of the dispatcher (e.g. passenger,
    unicorn, resque), framework (e.g. rails3, sinatra), and newrelic.yml
    location are now handled via the Agent environment, manual, and default
    configuration sources.

  * Updates to logging across the agent

    We've carefully reviewed the logging messages that the agent outputs, adding
    details in some cases, and removing unnecessary clutter. We've also altered
    the startup sequence to ensure that we don't spam STDOUT with messages
    during initialization.

  * Fix passing environment to manual_start()

    Thanks to Justin Hannus.  The :env key, when passed to Agent.manual_start,
    can again be used to specify which section of newrelic.yml is loaded.

  * Rails 4 support

    This release includes preliminary support for Rails 4 as of 4.0.0.beta.
    Rails 4 is still in development, but the agent should work as expected for
    people who are experimenting with the beta.

## v3.5.4 ##

  * Add queue time support for sinatra apps

    Sinatra applications can now take advantage of front end queue time
    reporting. Thanks to Winfield Peterson for this contribution.

  * Simplify queue time configuration for nginx 1.2.6+

    Beginning in version 1.2.6, recently released as a development version, the
    $msec variable can be used to set an http header.  This change allows front
    end queue time to be tracked in New Relic simply by adding this line to the
    nginx config:

    proxy_set_header X-Queue-Start "t=${msec}000"

    It will no longer be necessary to compile a patched version of nginx or
    compile in the perl or lua module to enable this functionality.

    Thanks to Lawrence Pit for the contribution.

  * Report back build number and stage along with version info

    In the 3.5.3 series the agent would fail to report its full version number
    to NewRelic's environment report.  For example it would report its version
    as 3.5.3 instead of 3.5.3.25 or 3.5.3.25.beta.  The agent will now report
    its complete version number as defined in newrelic_rpm.gemspec.

  * The host and the port that the agent reports to can now be set from environment vars

    The host can be set with NEW_RELIC_HOST and the port with NEW_RELIC_PORT.  These setting
    will override any other settings in your newrelic.yml.

  * Fix RUM reporting to multiple applications

    When the agent is configured to report to multiple "roll up" applications
    RUM did not work correctly.

## v3.5.3 ##

  * Update the collector protocol to use JSON and Ruby primitives

    The communication between the agent and the NewRelic will not longer be
    marshaled Ruby objects, but rather JSON in the case of Ruby 1.9 and marshaled
    Ruby primitives in the case of 1.8.  This results in greater harvest efficiency
    as well as feature parity with other New Relic agents.

  * Fix incorrect application of conditions in sinatra instrumentation

    The agent's sinatra instrumentation was causing sinatra's conditions to
    be incorrectly applied in some obscure cases.  The bug was triggered
    when a condition was present on a lower priority route that would match
    the current request, except for the presence of a higher priority route.

## v3.5.2 ##

 * Simplified process of running agent test suite and documented code
   contribution process in GUIDELINES_FOR_CONTRIBUTING.

## v3.5.1 ##

 * Enabling Memory Profiling on Lion and Mountain Lion

   The agent's list of supported platforms for memory profiling wasn't correctly checking
   for more recent versions of OS X.

 * Fixed an arity issue encountered when calling newrelic_notice_error from Rails applications.

 * End user queue time was not being properly reported, works properly now.

 * Server-side configuration for ignoring errors was not being heeded by agent.

 * Better handling of a thread safety issue.

   Some issues may remain, which we are working to address, but they should be gracefully handled
   now, rather than crashing the running app.

 * Use "java_import" rather than "include_class" when require Java Jars into a JRuby app.

   Thanks to Jan Habermann for the pull request

 * Replaced alias_method mechanism with super call in DataMapper instrumentation.

   Thanks to Michael Rykov for the pull request

 * Fixed the Rubinius GC profiler.

   Thanks to Dirkjan Bussink

 * Use ActiveSupport.on_load to load controller instrumentation Rails 3.

   Thanks to Jonathan del Strother

 * Reduce the number of thread local reference in a particular high traffic method

   Thanks to Jeremy Kemper

## v3.5.0.1 ##

 * (Fix) Due to a serious resource leak we have ended support for versions of Phusion Passenger
   older than 2.1.1. Users of older versions are encouraged upgrade to a more recent version.

## v3.5.0 ##

 * (Fix) RUM Stops Working After 3.4.2.1 Agent Upgrade

   v3.4.2.1 introduced a bug that caused the browser monitor auto instrumentation
   (for RUM) default to be false. The correct value of true is now used

 * When the Ruby Agent detects Unicorn as the dispatcher it creates an INFO level log message
   with additional information

   To help customers using Unicorn, if the agent detects it (Unicorn) is being used as the
   dispatcher an INFO level log message it created that includes a link to New Relic
   online doc that has additional steps that may be required to get performance data reporting.

 * (Fix) In version 3.4.2 of the Ruby Agent the server side value for Apdex T was disregarded

   With version 3.4.2 of the agent, the value set in the newrelic.yml file took precedence over the
   value set in the New Relic UI.  As of version 3.5.0 only the value for Apdex T set in the
   New Relic UI will be used. Any setting in the yaml file will be ignored.

 * Improved Error Detection/Reporting capabilities for Rails 3 apps

   Some errors are missed by the agent's exception reporting handlers because they are
   generated in the rails stack, outside of the instrumented controller action. A Rack
   middleware is now included that can detect these errors as they bubble out of the middleware stack.
   Note that this does not include Routing Errors.

 * The Ruby Agent now logs certain information it receives from the New Relic servers

   After connecting to the New Relic servers the agent logs the New Relic URL
   of the app it is reporting to.

 * GC profiling overhead for Ruby 1.9 reduced

   For Ruby 1.9 the amount of time spent in GC profiling has been reduced.

 * Know issue with Ruby 1.8.7-p334, sqlite3-ruby 1.3.0 or older, and resque 1.23.0

   The Ruby Agent will not work in conjunction with Ruby 1.8.7-p334, sqlite3-ruby 1.3.3
   or earlier, and resque 1.23.0. Your app will likely stop functioning. This is a known problem
   with Ruby versions up to 1.8.7-p334. Upgrading to the last release of Ruby 1.8.7
   is recommended.  This issue has been present in every version of the agent we've tested
   going back for a year.


## v3.4.2.1 ##

* Fix issue when app_name is nil

  If the app_name setting ends up being nil an exception got generated and the application
  wouldn't run. This would notably occur when running a Heroku app locally without the
  NEW_RELIC_APP_NAME environment variable set. A nil app_name is now detected and an
  error logged specifying remediation.

## v3.4.2 ##

 * The RUM NRAGENT tk value gets more robustly sanitized to prevent potential XSS vulnerabilities

   The code that scrubs the token used in Real User Monitoring has been enhanced to be
   more robust.

 * Support for Apdex T in server side configuration

   For those using server side configuration the Ruby Agent now supports setting
   the Apdex T value via the New Relic UI.

 * Refactoring of agent config code

   The code that reads the configuration information and configures the agent
   got substantially reorganized, consolidated, simplified, and made more robust.

## v3.4.1 ##
#### Bug Fixes ####
 * Fix edge case in RUM auto instrumentation where X-UA-Compatible meta tag is
   present but </head> tag is missing.

   There is a somewhat obscure edge case where RUM auto instrumentation will
   crash a request. The issue seems to be triggered when the X-UA-Compatible
   meta tag is present and the </head> tag is missing.

 * Fixed reference to @service.request_timeout to @request_timeout in
   new_relic_service.rb. (Thanks to Matthew Savage)

   When a timeout occurred during connection to the collector an "undefined
   method `request_timeout' for nil:NilClass'" would get raised.

 * preserve visibility on traced methods.

   Aliased methods now have the same visibility as the original traced method.
   A couple of the esoteric methods created in the process weren't getting the
   visibility  set properly.

 * Agent service does not connect to directed shard collector after connecting
   to proxy

   After connecting to collector proxy name of real collector was updated, but
   ip address was not being updated causing connections to go to the proxy.
   Agent now looks up ip address for real collector.

 * corrupt marshal data from pipe children crashing agent

   If the agent received corrupted data from the Reqsue worker child agent
   it could crash the agent itself. fixed.

 * should reset RubyBench GC counter between polls

   On Ruby REE, the GC profiler does not reset the counter between polls. This
   is only a problem if GC could happen *between* transactions, as in, for
   example, out-of-band GC in Unicorn. fixed.

## v3.4.0.1
 * Prevent the agent from resolving the collector address when disabled.
 * Fix for error collector configuration that was introduced during beta.
 * Preserve method visibility when methods are traced with #add_method_tracer and #add_transaction_tracer

## v3.4.0
 * Major refactor of data transmission mechanism.  This enabled child processes to send data to parent processes, which then send the data to the New Relic service.  This should only affect Resque users, dramatically improving their experience.
 * Moved Resque instrumentation from rpm_contrib to main agent.  Resque users should discontinue use of rpm_contrib or upgrade to 2.1.11.
 * Resolve issue with configuring the Error Collector when using server-side configuration.

## v3.3.5
 * [FIX] Allow tracing of methods ending in ! and ?
 * [PERF] Give up after scanning first 50k of the response in RUM
   auto-instrumentation.
 * [FIX] Don't raise when extracting metrics from SQL queries with non UTF-8 bytes.
 * Replaced "Custom/DJ Locked Jobs" metric with new metrics for
   monitoring DelayedJob: queue_length, failed_jobs, and locked_jobs, all under
   Workers/DelayedJob.  queue_length is also broken out by queue name or priority
   depending on the version of DelayedJob deployed.

## v3.3.4.1
 * Bug fix when rendering empty collection in Rails 3.1+

## v3.3.4
  * Rails 3 view instrumentation

## v3.3.3
  * Improved Sinatra instrumentation
  * Limit the number of nodes collected in long running transactions to prevent leaking memory

## v3.3.2.1
  * [SECURITY] fix for cookie handling by End User Monitoring instrumentation

## v3.3.2
  * deployments recipe change: truncate git SHAs to 7 characters
  * Fixes for obfuscation of PostgreSQL and SQLite queries
  * Fix for lost database connections when using a forking framework
  * Workaround for RedHat kernel bug which prevented blocking reads of /proc fs
  * Do not trap signals when handling exceptions

## v3.3.1
  * improved Ruby 1.8.6 support
  * fix for issues with RAILS_ROOT deprecation warnings
  * fixed incorrect 1.9 GC time reporting
  * obfuscation for Slow SQL queries respects transaction trace config
  * fix for RUM instrumentation repoting bad timing info in some cases
  * refactored ActiveRecord instrumentation, no longer requires Rails

## v3.3.0
  * fix for GC instrumentation when using Ruby 1.9
  * new feature to correlate browser and server transaction traces
  * new feature to trace slow sql statements
  * fix to help cope with malformed rack responses
  * do not try to instrument versions of ActiveMerchant that are too old

## v3.2.0.1
  * Updated LICENSE
  * Updated links to support docs

## v3.2.0
  * Fix over-detection of mongrel and unicorn and only start the agent when
    actual server is running
  * Improve developer mode backtraces to support ruby 1.9.2, windows
  * Fixed some cases where Memcache instrumentation was failing to load
  * Ability to set log destination by NEW_RELIC_LOG env var
  * Fix to mutex lib load issue
  * Performance enhancements (thanks to Jeremy Kemper)
  * Fix overly verbose STDOUT message (thanks to Anselm Helbig)

## v3.1.2
  * Fixed some thread safety issues
  * Work around for Ruby 1.8.7 Marshal crash bug
  * Numerous community patches (Gabriel Horner, Bradley Harris, Diego Garcia,
    Tommy Sullivan, Greg Hazel, John Thomas Marino, Paul Elliott, Pan Thomakos)
  * Fixed RUM instrumentation bug

## v3.1.1
  * Support for Rails 3.1 (thanks to Ben Hoskings via github)
  * Support for Rubinius
  * Fixed issues affecting some Delayed Job users where log files were not appearing
  * Fixed an issue where some instrumentation might not get loaded in Rails apps
  * Fix for memcached cas method (thanks to Andrew Long and Joseph Palermo )
  * Fix for logger deprecation warning (thanks to Jonathan del Strother via github)
  * Support for logging to STDOUT
  * Support for Spymemcached client on jruby

## v3.1.0
  * Support for aggregating data from short-running
    processes to reduce reporting overhead
  * Numerous bug fixes
  * Increased unit test coverage

## v3.0.1
  * Updated Real User Monitoring to reduce javascript size and improve
    compatibility, fix a few known bugs

## v3.0.0
  * Support for Real User Monitoring
  * Back end work on internals to improve reliability
  * added a 'log_file_name' and 'log_file_path' configuration variable to allow
    setting the path and name of the agent log file
  * Improve reliability of statistics calculations
  * Remove some previously deprecated methods
  * Remove Sequel instrumentation pending more work

## v2.14.1
  * Avoid overriding methods named 'log' when including the MethodTracer module
  * Ensure that all load paths for 'new_relic/agent' go through 'new_relic/control' first
  * Remove some debugging output from tests

## v2.14.0
  * Dependency detection framework to prevent multi-loading or early-loading
    of instrumentation files

## v2.13.5
  * Moved the API helper to the github newrelic_api gem.
  * Revamped queue time to include server, queue, and middleware time
  * Increased test coverage and stability
  * Add Trinidad as a dispatcher (from Calavera, on github)
  * Sequel instrumentation from Aman Gupta
  * patches to 1.9 compatibility from dkastner on github
  * Support for 1.9.2's garbage collection instrumentation from Justin Weiss
  * On Heroku, existing queue time headers will be detected
  * Fix rack constant scoping in dev mode for 1.9 (Rack != ::Rack)
  * Fixes for instrumentation loading failing on Exception classes that
    are not subclasses of StandardError
  * Fix active record instrumentation load order for Rails 3

## v2.13.4
  * Update DNS lookup code to remove hardcoded IP addresses

## v2.13.3
  * Dalli instrumentation from Mike Perham (thanks Mike)
  * Datamapper instrumentation from Jordan Ritter (thanks Jordan)
  * Apdex now defaults to 0.5
    !!! Please be aware that if you are not setting an apdex,
    !!! this will cause a change in the apparent performance of your app.
  * Make metric hashes threadsafe (fixes problems sending metrics in Jruby
    threaded code)
  * Delete obsolete links to metric docs in developer mode
  * Detect gems when using Bundler
  * Fix newrelic_ignore in Rails 3
  * Break metric parser into a separate vendored gem
  * When using Unicorn, preload_app: true is recommended to get proper
    after_fork behavior.

## v2.13.2
  * Remove a puts. Yes, a whole release for a puts.

## v2.13.1
  * Add missing require in rails 3 framework control

## v2.13.0
  * developer mode is now a rack middleware and can be used on any framework;
    it is no longer supported automatically on versions of Rails prior to 2.3;
    see README for details
  * memcache key recording for transaction traces
  * use system_timer gem if available, fall back to timeout lib
  * address instability issues in JRuby 1.2
  * renamed executable 'newrelic_cmd' to 'newrelic'; old name still supported
    for backward compatibility
  * added 'newrelic install' command to install a newrelic.yml file in the
    current directory
  * optimization to execution time measurement
  * optimization to startup sequence
  * change startup sequence so that instrumentation is installed after all
    other gems and plugins have loaded
  * add option to override automatic flushing of data on exit--send_data_on_exit
    defaults to 'true'
  * ignored errors no longer affect apdex score
  * added record_transaction method to the api to allow recording
    details from web and background transactions occurring outside RPM
  * fixed a bug related to enabling a gold trial / upgrade not sending
    transaction traces correctly

## v2.12.3
  * fix regression in startup sequence

## v2.12.2
  * fix for regression in Rails 2.1 inline rendering
  * workaround bug found in some rubies that caused a segv and/or NoMemoryError
    when deflating content for upload
  * avoid creating connection thread in unicorn/passenger spawners

## v2.12.1
  * fix bug in profile mode
  * fix race condition in Delayed::Job instrumentation loading
  * fix glassfish detection in latest glassfish gem

## v2.12.0
  * support basic instrumentation for ActsAsSolr and Sunspot

## v2.11.3
  * fix bug in startup when running JRuby

## v2.11.2
  * fix for unicorn not reporting when the proc line had 'master' in it
  * fix regression for passenger 2.0 and earlier
  * fix after_fork in the shim

## v2.11.1
  * republished gem without generated rdocs

## v2.11.0
  * rails3 instrumentation (no developer mode support yet)
  * removed the ensure_worker_thread started and instead defined an after_fork
    handler that will set up the agent properly in forked processes.
  * change at_exit handler so the shutdown always goes after other shutdown
    handlers
  * add visibility to active record db transactions in the rpm transaction
    traces (thanks to jeremy kemper)
  * fix regression in merb support which caused merb apps not to start
  * added NewRelic::Agent.logger to the public api to write to the agent
    log file.
  * optimizations to background thread, controller instrumentation, memory
    usage
  * add logger method to public_api
  * support list notation for ignored exceptions in the newrelic.yml

## v2.10.8
  * fix bug in delayed_job instrumentation that caused the job queue sampler
    to run in the wrong place
  * change startup sequence and code that restarts the worker loop
    thread
  * detect the unicorn master and dont start the agent; hook in after_fork
  * fix problem with the Authlogic metric names which caused errors in
    developer mode.  Authlogic metrics now adhere to the convention of
    prefixing the name with  'Custom'
  * allow more correct overriding of transaction trace settings in the
    call to #manual_start
  * simplify WorkerLoop and add better protection for concurrency
  * preliminary support for rails3

## v2.10.6
  * fix missing URL and referrer on some traced errors and transactions
  * gather traced errors *after* executing the rescue chain in ActionController
  * always load controller instrumentation
  * pick up token validation from newrelic.yml

## v2.10.5
  * fix bug in delayed_job instrumentation occurring when there was no DJ log

## v2.10.4
  * fix incompatibility with Capistrano 2.5.16
  * strip down URLs reported in transactions and errors to path only

## v2.10.3
  * optimization to reduce overhead: move background samplers into foreground thread
  * change default config file to ignore RoutingErrors
  * moved the background task instrumentation into a separate tab in the RPM UI
  * allow override of the RPM application name via NEWRELIC_APP_NAME environment variable
  * revised Delayed::Job instrumentation so no manual_start is required
  * send buffered data on shutdown
  * expanded support for queue length and queue time
  * remove calls to starts_with to fix Sinatra and non-rails deployments
  * fix problem with apdex scores recording too low in some circumstances
  * switch to jeweler for gem building
  * minor fixes, test improvements, doc and rakefile improvements
  * fix incompatibility with Hoptoad where Hoptoad was not getting errors handled by New Relic
  * many other optimizations, bug fixes and documentation improvements

## v2.10.2.
  * beta release of 2.10
  * fix bugs with Sinatra app instrumentation
  * minor doc updates

## v2.10.1.
  * alpha release of 2.10
  * rack support, including metal; ignores 404s; requires a module inclusion (see docs)
  * sinatra support, displays actions named by the URI pattern matched
  * add API method to abort transaction recording for in-flight transactions
  * remove account management calls from newrelic_api.rb
  * truncating extremely large transaction traces for efficiency
  * fix error reporting in recipes; add newrelic_rails_env option to recipes to
    override the rails env used to pull the app_name out of newrelic.yml
  * added TorqueBox recognition (thanks Bob McWhirter)
  * renamed config settings: enabled => monitor_mode; developer => developer_mode;
    old names will still work in newrelic.yml
  * instrumentation for DelayedJob (thanks Travis Tilley)
  * added config switches to turn off certain instrumentation when you aren't
    interested in the metrics, to save on overhead--see newrelic.yml for details.
  * add profiling support to dev mode; very experimental!
  * add 'multi_threaded' config option to indicate when the app is running
    multi-threaded, so we can disable some instrumentation
  * fix test failures in JRuby, REE
  * improve Net::HTTP instrumentation so it's more efficient and distinguishes calls
    between web and non-web transactions.
  * database instrumentation notices all database commands in addition to the core commands
  * add support for textmate to dev mode
  * added add_transaction_tracer method to support instrumenting methods as
    if they were web transactions; this will facilitate better visibility of background
    tasks and eventually things like rack, metal and Sinatra
  * adjusted apdex scores to reflect time spent in the mongrel queue
  * fixed incompatibility with JRuby on startup
  * implemented CPU measure for JRuby which reflects the cpu burn for
    all controller actions (does not include background tasks)
  * fixed scope issue with GC instrumentation, subtracting time from caller
  * added # of GC calls to GC instrumentation
  * renamed the dispatcher metric
  * refactored stats_engine code for readability
  * optimization: reduce wakeup times for harvest thread

## v2.10.0.
  * alpha release of 2.10
  * support unicorn
  * instrumentation of GC for REE and MRE with GC patch
  * support agent restarting when changes are made to the account
  * removed #newrelic_notice_error from Object class, replaced by NewRelic::Agent#notice_error
  * collect histogram statistics
  * add custom parameters to newrelic_notice_error call to display
    extra info for errors
  * add method disable_all_tracing(&block) to execute a block without
    capturing metrics
  * newrelic_ignore now blocks all instrumentation collection for
    the specified actions
  * added doc to method_tracer API and removed second arg
    requirement for add_method_tracer call
  * instrumentation for Net::HTTP
  * remove method_tracer shim to avoid timing problems in monitoring daemons
  * for non-rails daemons, look at APP_ROOT and NRCONFIG env vars for custom locations

## v2.9.9.
  * Disable at_exit handler for Unicorn which sometimes caused the
    agent to stop reporting immediately.

## v2.9.8.
  * add instrumentation for Net::HTTP calls, to show up as "External"
  * added support for validating agents in the cloud.
  * recognize Unicorn dispatcher
  * add NewRelic module definitions to ActiveRecord instrumentation

## v2.9.5.
  * Snow Leopard memory fix

## v2.9.4.
  * clamp size of data sent to server
  * reset statistics for passenger when forking to avoid erroneous data
  * fix problem deserializing errors from the server
  * fix incompatibility with postgres introduced in 2.9.

## v2.9.3.
  * fix startup failure in Windows due to memory sampler
  * add JRuby environment information

## v2.9.2.
  * change default apdex_t to 0.5 seconds
  * fix bug in deployments introduced by multi_homed setting
  * support overriding the log in the agent api
  * fix JRuby problem using objectspace
  * display custom parameters when looking at transactions in dev mode
  * display count of sql statements on the list of transactions in dev mode
  * fixes for merb--thanks to Carl Lerche

## v2.9.1.
  * add newrelic_ignore_apdex method to controller classes to allow
    you to omit some actions from apdex statistics
  * Add hook for Passenger shutdown events to get more timely shutdown
    notices; this will help in more accurate memory readings in
    Passenger
  * add newrelic_notice_error to Object class
  * optional ability to verify SSL certificates, note that this has some
    performance and reliability implications
  * support multi-homed host with multiple apps running on duplicate
    ports

## v2.9.0.
  Noteworthy Enhancements
  * give visibility to templates and partials in Rails 2.1 and later, in
    dev mode and production
  * change active record metrics to capture statistics in adapter log()
    call, resulting in lower overhead and improved visibility into
    different DB operations; only AR operations that are not hitting the
    query cache will be measured to avoid overhead
  * added mongrel_rpm to the gem, a standalone daemon listening for custom
    metric values sent from local processes (experimental); do mongrel_rpm
    --help
  * add API for system monitoring daemons (refer to KB articles); changed
    API for manual starting of the agent; refer to
    NewRelic::Agent.manual_start for details
  * do certificate verification on ssl connections to
    collector.newrelic.com
  * support instances appearing in more than one application by allowing a
    semicolon separated list of names for the newrelic.yml app_name
    setting.
  * combined agent logfiles into a single logfile
  * use rpm server time for transaction traces rather than agent time

  Developer Mode (only) Enhancements
  * show partial rendering in traces
  * improved formatting of metric names in traces
  * added number of queries to transactions in the transaction list
  * added some sorting options for the transaction list
  * added a page showing the list of active threads

  Compatibility Enhancements
  * ruby 1.9.1 compatibility
  * support concurrency when determining busy times, for 2.2 compatibility
  * in jruby, use Java used heap for memory sampling if the system memory
    is not accessible from an unsupported platform
  * jruby will no longer start the agent now when running the console or
    rake tasks
  * API support for RPM as a footnote add-in
  * webrick support restored

  Noteworthy bugfixes
  * sample memory on linux by reading /proc/#{$$}/status file
  * fixed ambiguous 'View' metrics showing up in controller breakdown
  * removed Numeric extensions, including round_to, and to_ms
  * using a different timeout mechanism when we post data to RPM
  * remove usage of Rails::Info which had a side effect of enabling
    ActiveRecord even when it wasn't an active framework
  * moved CPU sampler off background thread and onto the harvest thread
  * tests now run cleanly in any rails app using test:newrelic or
    test:plugins

  Agent improvements to support future RPM enhancements
  * add instrumentation to capture metrics on response codes; not yet
    working in rails 2.3.*
  * added http referrer to traced errors
  * capture gem requirements from rails
  * capture cpu utilization adjusted for processor count
  * transaction sampling

## v2.8.10.
  * fix thin support with rails 2.3.2 when using script/server
  * fix incompatibility with rails 2.3.2 and script/server options
    processing
  * minor tweak to environment gathering for gem mode

## v2.8.9.
  * fix problem finding the newrelic controller in dev mode
  * fix incompatibility with older versions of optparse
  * fix potential jvm problem with jruby
  * remove test:all task definition to avoid conflicts
  * change error message about window sampler in windows not supported to a
    warning message

## v2.8.8.
  * fix error with jruby on windows
  * fix problem where webrick was being incorrectly detected causing some
    problems with mongrel application assignments--had to disable webrick
    for now

## v2.8.7.
  * fix for ssl connection hanging problems
  * fix problem recognizing mongrel in rails 2.3.2
  * fastcgi support in rails 2.3.2
  * put back webrick support

## v2.8.6.
  * fix for capture_params when using file uploads in controller actions
  * use pure ruby NS lookup for collector host to eliminate possibly
    blocking applications

## v2.8.5.
  * fix reference to CommandError which was breaking some cap scripts
  * fix incompatibility with Rails 2.0 in the server API
  * fix problem with litespeed with Lite accounts
  * fix problem when ActiveRecord is disabled
  * moved merb instrumentation to Merb::Controller instead of
    AbstractController to address incompatibility with MailController
  * fix problem in devmode displaying sql with embedded urls

## v2.8.4.
  * fix bug in capistrano recipe causing cap commands to fail with error
    about not finding Version class

## v2.8.3.
  * refactor unit tests so they will run in a generic rails environment
  * require classes in advance to avoid autoloading.  this is to address
    incompatibilities with desert as well as more flexibility in gem
    initialization
  * fixed newrelic_helper.rb 1.9 incompatibility

## v2.8.2.
  * fix Ruby 1.9 syntax compatibility errors
  * update the class loading sanity check, will notify server of errors
  * fix agent output on script and rake task execution

## v2.8.1.
  * Convert the deployment information upload script to an executable and
    put in the bin directory.  When installed as a gem this command is
    symlinked to /usr/bin.  Usage: newrelic_cmd deployments --help
  * Fix issue invoking api when host is not set in newrelic.yml
  * Fix deployments api so it will work from a gem
  * Fix thin incompatibility in developer mode

## v2.8.0.
  * add beta of api in new_relic_api.rb
  * instrumented dynamic finders in ActiveRecord
  * preliminary support for capturing deployment information via capistrano
  * change memory sampler for solaris to use /usr/bin/ps
  * allow ERB in newrelic.yml file
  * merged support for merb into this version
  * fix incompatibility in the developer mode with the safe_erb plugin
  * fix module namespace issue causing an error accessing
    NewRelic::Instrumentation modules
  * fix issue where the agent sometimes failed to start up if there was a
    transient network problem
  * fix IgnoreSilentlyException message

## v2.7.4.
  * fix error when trying to serialize some kinds of Enumerable objects
  * added extra debug logging
  * added app_name to app mapping

## v2.7.3.
  * fix compatibility issue with 1.8.5 causing error with Dir.glob

## v2.7.2.
  * fix problem with passenger edge not being a detected environment

## v2.7.1.
  * fix problem with skipped dispatcher instrumentation

## v2.7.0.
  * Repackage to support both plugin and Gem installation
  * Support passenger/litespeed/jruby application naming
  * Update method for calculating dispatcher queue time
  * Show stack traces in RPM Transaction Traces
  * Capture error source for TemplateErrors
  * Clean up error stack traces.
  * Support query plans from postgres
  * Performance tuning
  * bugfixes

## v2.5.3.
  * fix error in transaction tracing causing traces not to show up

## v2.5.2.
  * fixes for postgres explain plan support

## v2.5.1.
  * bugfixes

## v2.5.0.
  * add agent support for rpm 1.1 features
  * Fix regression error with thin support

## v2.4.3.
  * added 'newrelic_ignore' controller class method with :except and :only options for finer grained control
    over the blocking of instrumentation in controllers.
  * bugfixes

## v2.4.2.
  * error reporting in early access

## v2.4.1.
  * bugfix: initializing developer mode

## v2.4.0.
  * Beta support for LiteSpeed and Passenger

## v2.3.7.
  * bugfixes

## v2.3.6.
  * bugfixes

## v2.3.5.
  * bugfixes: pie chart data, rails 1.1 compatibility

## v2.3.4.
  * bugfix

## v2.3.3.
  * bugfix for non-mysql databases

## v2.3.2.
  * bugfixes
  * Add enhancement for Transaction Traces early access feature

## v2.3.1.
  * bugfixes

## v2.3.0.
  + Add support for Transaction Traces early access feature

## v2.2.2.
  * bugfixes

## v2.2.1.
  + Add rails 2.1 support for Developer Mode
  + Changes to memory sampler: Add support for JRuby and fix Solaris support.
  * Stop catching exceptions and start catching StandardError; other exception cleanup
  * Add protective exception catching to the stats engine
  * Improved support for thin domain sockets
  * Support JRuby environments

## v2.1.6.
  * bugfixes

## v2.1.5.
  * bugfixes

## v2.1.4.
  * bugfixes

## v2.1.3.
  * bugfixes

## v2.1.2.
  * bugfixes

## v2.1.1.
  * bugfixes

## v2.1.0.
  * release for private beta
