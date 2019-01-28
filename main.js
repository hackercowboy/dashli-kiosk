import { app, BrowserWindow } from 'electron';

let window = null;
const url = process.env.URL;
const width = process.env.WIDTH || 1920;
const height = process.env.HEIGHT || 1080;

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit();
  }
});

app.on('ready', () => {
  window = new BrowserWindow({
    width: parseInt(width, 10),
    height: parseInt(height, 10),
    frame: false,
    webPreferences: { webSecurity: false, allowRunningInsecureContent: true },
  });

  window.URL = url;
  window.WIDTH = width;
  window.HEIGHT = height;

  window.webContents.session.webRequest.onHeadersReceived({}, (detail, callback) => {
    const xFrameOriginKey = Object.keys(detail.responseHeaders).find(header => String(header).match(/^x-frame-options$/i));
    if (xFrameOriginKey) {
      /* eslint-disable no-param-reassign */
      delete detail.responseHeaders[xFrameOriginKey];
    }
    callback({ cancel: false, responseHeaders: detail.responseHeaders });
  });

  window.webContents.on('did-finish-load', () => {
    setTimeout(() => {
      window.show();
    }, 300);
  });

  window.loadURL(`file://${__dirname}/index.html`);
  window.on('closed', () => {
    window = null;
  });
});
