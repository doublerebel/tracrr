tracrr
======

Watches and logs V8 events using the internal programmatic debugger


Usage:

    Tracrr = require("lib/tracrr");
    Tracrr.logTo(console);

Launch V8 with `--expose-debug-as <name>` so that Tracrr can access `<name>.Debug` object from within JavaScript.

[Definition in V8 source](https://github.com/v8/v8/blob/98b05f59ff22cbb268ef09869a7925a44216867c/src/flag-definitions.h#L406): expose debug in global object
[Effect in V8 source](https://github.com/v8/v8/blob/df14a2c7e31b0730e789ef5c7acb88f64aa9e6d2/src/bootstrapper.cc#L2227): Creates an isolated Debug context that can call across to the main context

Flag can be set from command line (i.e. when launching node), or programmatically (i.e. when embedded [as in Titanium Mobile](https://github.com/doublerebel/titanium_mobile/commit/5c0d472650fa658405d364a05aad87bad9591e0e#L0R165))


This is a mostly undocumented feature of V8 that until now has been exclusively used to run V8's debugger test suite in JS.  More documentation coming soon.  For hints see source.  MIT Licensed.  2013 @doublerebel

