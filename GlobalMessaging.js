const Axios = require('axios')

const messageSend = async () => {
    Axios.post('https://apis.roblox.com/messaging-service//v1/universes/2232140200/topics/GlobalAnnouncement', { 'message': 'Announcement' }), {
        headers: {
            'x-api-key': 'sYrpVN+a9k+v10mMONK6aRTknfqtjm6hcRz/uiPQUbgZTgADZXlKaGJHY2lPaUpTVXpJMU5pSXNJbXRwWkNJNkluTnBaeTB5TURJeExUQTNMVEV6VkRFNE9qVXhPalE1V2lJc0luUjVjQ0k2SWtwWFZDSXNJbU4wZVNJNklrcFhWQ0o5LmV5SmlZWE5sUVhCcFMyVjVJam9pYzFseWNGWk9LMkU1YXl0Mk1UQnRUVTlPU3paaFVsUnJibVp4ZEdwdE5taGpVbm92ZFdsUVVWVmlaMXBVWjBGRUlpd2liM2R1WlhKSlpDSTZJakUyTWpZeE5qRTBOemtpTENKaGRXUWlPaUpTYjJKc2IzaEpiblJsY201aGJDSXNJbWx6Y3lJNklrTnNiM1ZrUVhWMGFHVnVkR2xqWVhScGIyNVRaWEoyYVdObElpd2laWGh3SWpveE56STFNVE01TkRrd0xDSnBZWFFpT2pFM01qVXhNelU0T1RBc0ltNWlaaUk2TVRjeU5URXpOVGc1TUgwLlRMVVlhTHhZbUxGd2JQWEpfYmthYUFkV0VtRkhiQkZDRnNqRmZuWjBJbVRMM29QVjI3a0RkaXpleWlwX2loODN3bFpITXRQcFFSckJuWjNSZ0VvT0NscWRDSXh5cEZ2ZjJQTEM2Unlwd1JNa1pPZldNazhESXNCUjNwOEl6Q0NTQ0RFNDBOdkgtTG56XzJ1S3VnTlRPZzQ4cHFScm90N3FWNkU3ZE9Hd0h0YWRGanhEbGVvbnYwMUhYeTJsNXpZcWt5S1ZwRHgzVDRjUHZsNWVaNGJDYTV6UU90YXZjZkNVY3dZdmY2aUtSMks1ZmNrY3NVYXpaZXN0ODRyUXJxZXhFZ1RXeXNqclh4NWQtUkw0YUdiSFRQRjdTNzQ3UnBxZnRMdkh1TzhtZTFFUC1LVnQtWk5BWnYxT1Z0Y0JfSWJsZm01TzdCUF9adnFkdzlGanlQeEFtUQ==',
            'Content-Type': 'application/json'
        }
    }
}

messageSend()