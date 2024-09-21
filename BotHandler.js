const { client, IntentsBitField, Client } = require('discord.js');

const client = new client({
    intents: [
        IntentsBitField.Flags.Guilds,
        IntentsBitField.Flags.GuildMembers,
        IntentsBitField.Flags.GuildMessages,
    ]
});

client.on('ready', (c) => {
    console.log(`${c.user.tag}`)
})

client.on('messageCreate', (message) => {
    if (message.content === 'hello') {
        message.reply('hiya')
    }
})

client.login("MTI4MTc4ODYwMjYyNzM5MTU1OQ.GQe9jc.1lMIHl7Vf5xch6uPWXJaNe7VU2Csuk2NxIb-zM");