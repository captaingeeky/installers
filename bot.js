const Discord = require('discord.js');
const botconfig = require('./botconfig.json');
const cmc_api = require('cmc-info');
let cmc = new cmc_api(botconfig.cmctoken);
const bot = new Discord.Client();
const genchannel = `415334876129263653`;
bot.on('ready', () => {
    console.log(' >NameCheck Bot Ready....');
    var minutes = 5, the_interval = minutes * 60 * 1000;
    setInterval(function() {
  console.log("I am doing my 5 minutes check");
  // do your stuff here
  cmc.requestCoinBySymbol('XLQ', 'price')
  	.then(data => {
      console.log(datetime.now().toString + " price " + data.toString().slice(0,6));
      bot.user.setNickname("XLQ-USD " + data.toString().slice(0,6));
  	})
  	.catch(error => {
  		console.error(error);
  	});


}, the_interval);
});

bot.on('guildMemberAdd', member => {
        var nameCheck = member.displayName.toUpperCase()
        // add uppercase || (or) conditions to the list for more names to check here
        if(["JARED GREY", "TOMWRX", "DAVID WILSON", "FELIX HUBER", "NASH"].find(name => nameCheck === name)) {
            bot.channels.get(genchannel).send(member.user.tag + " is impersonating " + member.displayName);
            //member.ban();
            console.log(member.user.tag + " is impersonating " + member.displayName);
        }
});

bot.on('guildMemberUpdate', (oldMember, newMember) => {
    if (oldMember.displayName !== newMember.displayName || oldMember.user.username !== newMember.user.username) {
        var nameCheck = newMember.displayName.toUpperCase()
        // add uppercase || (or) conditions to the list for more names to check here
        if(["JARED GREY", "TOMWRX", "DAVID WILSON", "FELIX HUBER", "NASH"].find(name => nameCheck === name)) {
             bot.channels.get(genchannel).send(oldMember.user.tag + " is impersonating a user and has changed his name to " + newMember.displayName + " ! ");
             //newmember.ban();
             console.log(oldMember.user.tag + " is impersonating a user and has changed his name to " + newMember.displayName + " ! ");
        }
    }
});

bot.login(botconfig.token);
