# Tracrr https://github.com/doublerebel/tracrr
#
# Watches and logs V8 events using the internal programmatic debugger

_logCaughtExceptions = true
_maxFrames = 12
_service = console or log: ->


class Tracrr
  @setLogCaughtExceptions: (logCaughtExceptions) -> _logCaughtExceptions = logCaughtExceptions
  @setMaxFrames: (maxFrames) -> _maxFrames = maxFrames

  @logTo: (service) ->
    _service = service
    @attach() unless @attached

  @attached: false # no debug.getListener method exists

  @attach: ->
    # Looks for --expose-debug-as debug
    # i.e. https://github.com/doublerebel/titanium_mobile/commit/5c0d472650fa658405d364a05aad87bad9591e0e#L0R165
    @Debug ?= debug.Debug
    @Debug.setListener @trace
    @Debug.debuggerFlags().breakOnCaughtException.setValue true
    @attached = true

  @detach: ->
    @Debug?.setListener null
    @Debug.debuggerFlags().breakOnCaughtException.setValue false
    @attached = false

  # This function executes in its own Debug context
  # Except for _service, _logCaughtExceptions, _maxFrames
  @trace: (event, exec_state, event_data, data) ->
    return unless (event is @Debug.DebugEvent.Exception) and (uc = event_data.uncaught()) or _logCaughtExceptions
    ex =
      # Find more data fields:
      # https://github.com/v8/v8/blob/master/src/debug.cc
      # https://github.com/v8/v8/blob/master/src/debug-debugger.js
      # https://github.com/v8/v8/blob/master/src/mirror-debugger.js
      # https://github.com/v8/v8/blob/master/test/mjsunit/debug-event-listener.js
      frameFuncName: exec_state.frame().func().name()
      exception:     event_data.exception()
      script:        exec_state.frame().func().script().name()
      line:          event_data.sourceLine() + 1
      column:        event_data.sourceColumn() + 1
      text:          event_data.sourceLineText()
      caught:        if uc then "Uncaught" else "Caught"

    frames = exec_state.frameCount() - 1
    frames = _maxFrames if frames > _maxFrames
    stackTrace = for frame in [1..frames]
      sf = exec_state.frame frame++
      fnc = sf.func()
      fname = fnc.name()
      fname = fnc.inferredName() if fname is ""
      "At #{fname} in #{fnc.script().name()}[#{sf.sourceLine() + 1},#{sf.sourceColumn() + 1}] #{sf.sourceLineText()}"

    exText = """#{ex.caught} Exception: #{ex.exception}
At #{ex.frameFuncName} in #{ex.script}[#{ex.line},#{ex.column}] #{ex.text}"""
    exText += "\n" + stackTrace.join "\n"
    _service.log exText


module.exports = Tracrr
