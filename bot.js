const Discord = require('discord.js');
const botconfig = require('./botconfig.json');
const bot = new Discord.Client();

bot.on('ready', () => {
    console.log(' >NameCheck Bot Ready....');
});

bot.on('guildMemberAdd', member => {
        var nameCheck = member.nickname.toUpperCase()
        // add uppercase || (or) conditions to the list for more names to check
        if(["JARED GREY", "TOMWRX", "DAVID WILSON", "FELIX HUBER", "NASH"].find(name => nameCheck === name)) {
            bot.channels.find("name", "general_chat").send(member.nickname + " is impersonating a user !!!");
            //member.ban()
        }
});

bot.on('guildMemberUpdate', (oldMember, newMember) => {
    if (oldMember.nickname !== newMember.nickname || oldMember.user.username !== newMember.user.username) {
        var nameCheck = newMember.nickname.toUpperCase()
        // add uppercase || (or) conditions to the list for more names to check
        if(["JARED GREY", "TOMWRX", "DAVID WILSON", "FELIX HUBER", "NASH"].find(name => nameCheck === name)) {
             bot.channels.find("name", "general_chat").send(oldMember.nickname + " is impersonating a user and has changed his name to " + newMember.nickname + " ! ");
             //member.ban()
        }
    }
});


bot.login(botconfig.token);
