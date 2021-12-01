const { app, BrowserWindow, screen } = require('electron')
const { join } = require('path')
const express = require('express')
const server = express()
const dev = process.env.NODE_ENV !== 'production'
const port = process.env.PORT || 8080

function createWindow () {

  // we want to set the full size of the window, without relying on kiosk mode
  const { width, height } = screen.getPrimaryDisplay().workArea

  const mainWindow = new BrowserWindow({
    width,
    height,
    autoHideMenuBar: true,
    kiosk: !dev,
    backgroundColor: '#ffffff'
  })

  mainWindow.loadURL(`http://localhost:${port}/`)
  if (dev) mainWindow.webContents.openDevTools()
}

app.on('window-all-closed', () => app.quit())

server.get('/', (req, res) => {
  res.sendFile(join(__dirname, 'index.html'))
})

app.whenReady().then(() => {
  // create the server
  server.listen(port, () => {
    // load window after the server is done setting up
    createWindow()
    console.log(`Server listening at: http://localhost:${port}/`)
  })
  
  app.on('activate', function () {
    if (BrowserWindow.getAllWindows().length === 0) createWindow()
  })
})
