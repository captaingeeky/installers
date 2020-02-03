const Discord = require('discord.js');
const botconfig = require('./botconfig.json');
const bot = new Discord.Client();
const genchannel = bot.guild.channels.find(channel => channel.name === "general_chat");
bot.on('ready', () => {
    console.log(' >NameCheck Bot Ready....');
});

bot.on('guildMemberAdd', member => {
        var nameCheck = member.displayName.toUpperCase()
        // add uppercase || (or) conditions to the list for more names to check
        if(["JARED GREY", "TOMWRX", "DAVID WILSON", "FELIX HUBER", "NASH"].find(name => nameCheck === name)) {
            genchannel.send(member.displayName + " is impersonating a user !!!");
            //member.ban()
              console.log(member.displayName + " is impersonating a user !!!");
        }
});

bot.on('guildMemberUpdate', (oldMember, newMember) => {
    if (oldMember.displayName !== newMember.displayName || oldMember.user.username !== newMember.user.username) {
        var nameCheck = newMember.displayName.toUpperCase()
        // add uppercase || (or) conditions to the list for more names to check
        if(["JARED GREY", "TOMWRX", "DAVID WILSON", "FELIX HUBER", "NASH"].find(name => nameCheck === name)) {
             genchannel.send(oldMember.displayName + " is impersonating a user and has changed his name to " + newMember.displayName + " ! ");
             //member.ban()
               console.log(oldMember.displayName + " is impersonating a user and has changed his name to " + newMember.displayName + " ! ");
        }
    }
});


bot.login(botconfig.token);
