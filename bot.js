const Discord = require('discord.js');
const botconfig = require('./botconfig.json');
const bot = new Discord.Client();

bot.on('ready', () => {
    console.log(' >NameCheck Bot Ready....');
});

bot.on('guildMemberAdd', member => {
        var nameCheck = member.displayName.toUpperCase()
        // add uppercase || (or) conditions to the list for more names to check here
        if(["JARED GREY", "TOMWRX", "DAVID WILSON", "FELIX HUBER", "NASH"].find(name => nameCheck === name)) {
          const genchannel = bot.channels.get(`415334876129263653`);
            genchannel.send(member.displayName + " is impersonating a user !!!");
            //member.ban()
            member.setNickname('SCAMMER');
              console.log(member.displayName + " is impersonating a user !!!");
        }
});

bot.on('guildMemberUpdate', (oldMember, newMember) => {
    if (oldMember.displayName !== newMember.displayName || oldMember.user.username !== newMember.user.username) {
        var nameCheck = newMember.displayName.toUpperCase()
        // add uppercase || (or) conditions to the list for more names to check here
        if(["JARED GREY", "TOMWRX", "DAVID WILSON", "FELIX HUBER", "NASH"].find(name => nameCheck === name)) {
          const genchannel = bot.channels.get(`415334876129263653`);
             genchannel.send(oldMember.displayName + " is impersonating a user and has changed his name to " + newMember.displayName + " ! ");
             //member.ban()
               console.log(oldMember.displayName + " is impersonating a user and has changed his name to " + newMember.displayName + " ! ");
               member.setNickname('SCAMMER');
        }
    }
});


bot.login(botconfig.token);
