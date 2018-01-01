
## Two-day Prototyping Exercise (Haim Gelfenbeyn)

### Technology used

 * Framework: [Roda](https://github.com/jeremyevans/roda).
 * Storage: [Sequel](https://github.com/jeremyevans/sequel) with SQLite3 driver.
 * Websockets: [Faye-websocket](https://github.com/faye/faye-websocket-ruby)
 * [Semantic UI](https://semantic-ui.com/) (CSS framework)
 * jQuery

### Limitations

This is just a prototype, and should not be mistaken for a production-quality code. Some (but not all) of limitations,
not necessarily in the order of importance:

 1. No authentication whatsoever.
 2. Security: very limited testing was done with regards to XSS and CSRF protection.
 3. Testing is non-existent. I just added some scaffolding where real test cases should go.
 4. Assets are not optimized/compressed/combined, everything is delivered in development mode.
 5. Parameters validation is limited, error messages are of low quality.
 6. Websockets implementation is just a proof of concept, nowhere near production-quality code. It supports
    single-instance web servers only, no reconnection support on client side, no authentication no versioning, etc.

### API limitation

I think proper feedback is it's very important in HA application. The API as described does not provide ways to receive
notifications when HA controls are modified outside of this applications, so internal state will eventually go out of
sync with the real state of device (e.g. someone uses the volume button on the TV remote). This has to be mitigated in
real application.

### Error handling and recovery

 * Upon an unsuccessful API call, the application currently just displays a message with an exception message, verbatim,
in the UI. In a real world application, most common failure modes should be investigated, and their specific messages
amended with specific instructions to the user how to resolve this spefific problem. (e.g. "plug the TV in" on
a timeout error).

 * The application still should have a mechanism to reset all settings to "factory defaults", both manually and when
 an unrecoverable database corruption is detected (even though SQLite is pretty resilient, this still can happen).

### Websockets

I've added some initial websockets support so the state is reflected in the application whenever it is changed
elsewhere (Open two tabs with the same device control side by side, changing one should change the other immediately,
without reloading). Of course, without proper support on the API side, this is of a limited use.

One additional benefit for this feature is that if the API call fails, the control reverts back to the state it was
before in the GUI (applicable to sliders and selects and not buttons, of course).

### Proxy support

I've tested this behind a proxy, and websockets are broken. I don't believe this to be a serious issue at this point, 
especially since the intended setup is both client and the server on the same home LAN.
