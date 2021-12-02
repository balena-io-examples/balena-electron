const { app, BrowserWindow, screen } = require('electron')
const { join } = require('path')
const express = require('express')
const server = express()
const dev = process.env.NODE_ENV !== 'production'
const port = process.env.PORT || 8080

function createWindow () {
  // we want to set the full size of the window
  const { width, height } = screen.getPrimaryDisplay().workArea

  // setup the main browser window
  const mainWindow = new BrowserWindow({
    width,
    height,
    autoHideMenuBar: true,
    kiosk: !dev,
    backgroundColor: '#ffffff'
  })

  // we will be loading our locally hosted express server as the main URL
  mainWindow.loadURL(`http://localhost:${port}/`)

  // open chrome dev tools if we are in dev mode
  if (dev) mainWindow.webContents.openDevTools()
}

// we want to quit the application if all windows have been closed manually
app.on('window-all-closed', () => app.quit())

// we only have one express route, and it serves up our HTML file
server.get('/', (req, res) => {
  res.sendFile(join(__dirname, 'index.html'))
})

// wait until electron is ready to go
app.whenReady().then(() => {
  // create the express server
  server.listen(port, () => {
    console.log(`Server listening at: http://localhost:${port}/`)

    // start our window after the server is listening and ready
    createWindow()
  })
})
