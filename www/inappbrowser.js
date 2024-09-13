(function () {
  var exec = require ('cordova/exec');
  var channel = require ('cordova/channel');
  var modulemapper = require ('cordova/modulemapper');
  var urlutil = require ('cordova/urlutil');

  function InAppBrowser () {
    this.channels = {
      beforeload: channel.create ('beforeload'),
      loadstart: channel.create ('loadstart'),
      loadstop: channel.create ('loadstop'),
      loaderror: channel.create ('loaderror'),
      exit: channel.create ('exit'),
      customscheme: channel.create ('customscheme'),
      message: channel.create ('message'),
    };
  }

  InAppBrowser.prototype = {
    _eventHandler: function (event) {
      if (event && event.type in this.channels) {
        if (event.type === 'beforeload') {
          this.channels[event.type].fire (
            event,
            this._loadAfterBeforeload.bind (this)
          );
        } else {
          this.channels[event.type].fire (event);
        }
      }
    },
    _loadAfterBeforeload: function (strUrl) {
      strUrl = urlutil.makeAbsolute (strUrl);
      exec (null, null, this.rootName, 'loadAfterBeforeload', [strUrl]);
    },
    close: function (eventname) {
      exec (null, null, this.rootName, 'close', []);
    },
    show: function (eventname) {
      exec (null, null, this.rootName, 'show', []);
    },
    hide: function (eventname) {
      exec (null, null, this.rootName, 'hide', []);
    },
    addEventListener: function (eventname, f) {
      if (eventname in this.channels) {
        this.channels[eventname].subscribe (f);
      }
    },
    removeEventListener: function (eventname, f) {
      if (eventname in this.channels) {
        this.channels[eventname].unsubscribe (f);
      }
    },

    executeScript: function (injectDetails, cb) {
      if (injectDetails.code) {
        exec (cb, null, this.rootName, 'injectScriptCode', [
          injectDetails.code,
          !!cb,
        ]);
      } else if (injectDetails.file) {
        exec (cb, null, this.rootName, 'injectScriptFile', [
          injectDetails.file,
          !!cb,
        ]);
      } else {
        throw new Error (
          'executeScript requires exactly one of code or file to be specified'
        );
      }
    },

    insertCSS: function (injectDetails, cb) {
      if (injectDetails.code) {
        exec (cb, null, this.rootName, 'injectStyleCode', [
          injectDetails.code,
          !!cb,
        ]);
      } else if (injectDetails.file) {
        exec (cb, null, this.rootName, 'injectStyleFile', [
          injectDetails.file,
          !!cb,
        ]);
      } else {
        throw new Error (
          'insertCSS requires exactly one of code or file to be specified'
        );
      }
    },
    rootName: 'InAppBrowser',
  };

  module.exports = {
    open: function (strUrl, strWindowName, strWindowFeatures, callbacks) {
      console.log ('Started Open');
      // Don't catch calls that write to existing frames (e.g. named iframes).
      if (window.frames && window.frames[strWindowName]) {
        var origOpenFunc = modulemapper.getOriginalSymbol (window, 'open');
        return origOpenFunc.apply (window, arguments);
      }

      strUrl = urlutil.makeAbsolute (strUrl);
      console.log (strUrl);
      var iab = new InAppBrowser ();
      iab.rootName = 'InAppBrowser';

      callbacks = callbacks || {};
      for (var callbackName in callbacks) {
        iab.addEventListener (callbackName, callbacks[callbackName]);
      }

      var cb = function (eventname) {
        iab._eventHandler (eventname);
      };

      strWindowFeatures =
        strWindowFeatures ||
        'location=no,lefttoright=no,closebuttoncaption=X,toolbartranslucent=yes,toolbarposition=top,hidenavigationbuttons=yes,hideurlbar=yes,toolbarcolor=#FFFFFF,closebuttoncolor=#FF0000';

      if (strUrl.includes ('?external')) strWindowName = '_system';

      exec (cb, cb, 'InAppBrowser', 'open', [
        strUrl,
        strWindowName || '_blank',
        strWindowFeatures,
      ]);
      return iab;
    },
    openSystemBrowser: function (
      strUrl,
      strWindowName,
      strWindowFeatures,
      callbacks
    ) {
      if (window.frames && window.frames[strWindowName]) {
        var origOpenFunc = modulemapper.getOriginalSymbol (window, 'open');
        return origOpenFunc.apply (window, arguments);
      }

      strUrl = urlutil.makeAbsolute (strUrl);
      var iab = new InAppBrowser ();
      iab.rootName = 'SystemInAppBrowser';

      callbacks = callbacks || {};
      for (var callbackName in callbacks) {
        iab.addEventListener (callbackName, callbacks[callbackName]);
      }

      var cb = function (eventname) {
        iab._eventHandler (eventname);
      };

      strWindowFeatures = strWindowFeatures || '';

      exec (cb, cb, 'SystemInAppBrowser', 'open', [
        strUrl,
        strWindowName,
        strWindowFeatures,
      ]);
      return iab;
    },
  };
}) ();
