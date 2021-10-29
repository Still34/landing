---
title: Facebook, Monopoly, and Barinsta
excerpt: Facebook and its anti-competitive strategy.
category: personal
header:
  overlay_color: '#000'
  overlay_filter: '0.75'
toc: true
---

# Facebook, Monopoly, and Barinsta

Last week of October 2021 marks the week that my second Instagram account got suspended. My first and my main Instagram account that was created since 2013 was suspended on the last week of September 2021 as well. Over what? We'll get into that later, but first, let's talk about the problem with Facebook, neoliberalism and monolopy.

## Business Model of Facebook

No one gets to use a large-scale service for free - someone has to be the one that pays the bills. What business model does Facebook employ then? Why of course through advertisements! Advertisers pay Facebook a small (or ridiclously high) amount of fee to have their ads posted and delivered to users. Now, this is usually fine, and most people understand this. Getting ads every now and then to make up for the number of storage and or traffic we use on the service, perfectly reasonable. So what's the problem then?

Ads optimization.

How does Facebook know what ads it should serve people? Through analytics and tracking, and it turns out Facebook excels at this. After all, they've been in the advertisement business for over a decade. How does this work? A small section of your user data, such as gender, age, interests, location, is collected from you when you sign up for the service and or begin creating UGCs (User Generated Content). This is explictly stated in their Privacy Policy (which most people don't read). Facebook claims that the user data is never sent to the advertisers, and they will never get access to your personal info. However, this still does mean that Facebook now technically owns both your UGCs and this small section of information they have collected. 

This might be somewhat okay with some people if this data collection is an opt-in behavior. However, it is not. Facebook (and in turn, Instagram) does not allow you to *not* send "potentially sensitive" information when using their service - and that's because Facebook does not care about user privacy. If whatever it is they are doing makes the advertisers happy and the cash flowing in, they are willing to go through all sorts of lengths to get to that goal. 

Shortly after creating a new Instagram account, it somehow quickly caught up where I physically was located, what language I wrote in, what I may be interested in despite the fact that I have all sorts of protection measures in place (e.g., not telling where Facebook I was, disabling its location services and permissions, using a proper VPN that does not collect user logs) - and remember, customers should *not* need to go through all these measures just to not get bombarded with ads. The worst part? You can't even reset the advertisement tracking behavior or preferences. 

Despite the fact how Facebook wants you to know "how important privacy is to us (the billion dollar company that runs the Internet)" by creating multiple dedicated privacy policy pages and showing priacy control options, they are merely trying to create an image that sells you the idea that "hey, it's ok if you don't want us to invade your privacy." When, in fact, they just show you what they know about you, and there's absolutely nothing you can do about it (or at least, the part that matters to each indvidual).

### Jedi Blue 

Let's switch gear and talk about the Jedi Blue agreement. This agreement was not revealed (to my knowledge) until the court case 1:2021cv06841, an antitrust suit against Google LLC. The legal document spans 173 pages, and while lengthy (though I still encourage you to read it), reveals interesting tidbits about how both Google and Facebook works when it comes to advertisements. To put simply: they do not care about user privacy. 

Essentially, Facebook and Google met in closed-door meetings and signed what they called a Jedi Blue Agreement.

> In  the  Jedi  Blue  agreement,  Google  and  Facebook  agreed  to  manipulate  publisher  
auctions in Facebook’s favor through secret bid, spend, and win commitments. 
> \[...\]
> The Jedi Blue agreement allocates markets, and therefore fixes prices, between Google 
and  Facebook  as  competing  bidders  in  the  auctions  for  publishers’  web  display  and  in-app 
advertising inventory. The agreement allocated a portion of publishers’ auction wins to Facebook, 
subverting the free operation of supply and demand. Furthermore, the bid rate, win rate, and spend 
commitments  were  designed  to  meet  a  “high  monthly  minimum  to  ensure  volume”  that  spans 
several years. Facebook is locked in and cannot change its mind and switch back to header bidding 
to compete against Google in the publisher ad server market.
> - The State Of Texas, et al v. Google, LLC (2021)

Basically, Google and Facebook agreed to monopolize the ads market together - and they knew an antitrust case would eventually be filed against them.

> The  agreement  also  
requires the parties to coordinate on antitrust defenses, such that Facebook must approve any and 
all  arguments  that  Google  presents  relating  to  their  illegal  agreement  in  its  answer  to  this  Complaint.
> - The State Of Texas, et al v. Google, LLC (2021)

### FTC Antitrust Case

In court case 1:20-cv-03590-JEB (basically that one antitrust case where the FTC sued Facebook), Facebook was also scrutunized for having a huge market power to manipulate users into believing their products and services,

> More generally, Facebook has also engaged in other activities that have degraded 
the user experience, including the misusing or mishandling of user data.  For example, the FTC 
charged Facebook with engaging in a range of serious user privacy and related abuses in 2012 and 
2019,  and  both  times  Facebook  agreed  to  Consent  Orders  (and,  in  2019,  to  pay  a  $5  billion  penalty).    Facebook’s  ability  to  harm  users  by  decreasing  product  quality,  without  losing  
significant user engagement, indicates that Facebook has market power. 
> \[...\]
> Facebook navigated this period of transition, and has maintained its monopoly 
power in personal social networking thereafter, not by competing on the merits, but rather through a course of anticompetitive conduct spanning years. This course of conduct includes at least: 
a. the acquisition and continued control of Instagram, which has neutralized a 
significant independent personal social networking provider; 
b. the acquisition and continued control of WhatsApp, which has neutralized a 
significant competitive threat to Facebook’s personal social networking monopoly; 
and 
c. the imposition and enforcement of anticompetitive conditions on access to APIs in 
order to suppress and deter competitive threats to its personal social networking 
monopoly.
> - FEDERAL TRADE COMMISSION v. FACEBOOK INC. (2020)

Instagram is a advertisement platform. That's it. User privacy is not the utmost important to them. Thousands upon thousands of people are tired of anti-consumer behaviors like this, and this is why an open-source alternative was born, Barinsta.

## Enter Barinsta and its Demise

I started using Barinsta some time early 2021 when I got tired of Instagram's analytics, internal tracking, and giving me an ad every other Story I viewed. Barinsta is more or less based on the existing web version of the Instagram, but adapted in a way that is far more friendly to use than the default web Instagram.

It allows the user to view and or download Instagram photos anonymously or as a standard user - with all the tracking and ads stripped out. One could also view Stories and or DMs without marking the conversation as read, and so many other features that would make Instagram a superior usage experience. In fact, I was so impressed with it, I reached out to the developer and offered to work on localizing the app to Chinese Traditional (zh-TW). 

Unfortunately, this was short-lived.

Facebook hit the developer with [a Cease & Desist letter](https://github.com/austinhuang0131/austinhuang0131/issues/2), effectively demanding the developer to drop all work related to Barinsta development. This is unfortunately nothing new when it comes to Facebook vs. community projects or anything they see as a "financial threat."

[Frost for Facebook](https://github.com/AllanWang/Frost-for-Facebook) is an OSS alternative to the standard Facebook client on Android. It is based on the standard web version of Facebook but is adopted into a new container that isn't riddled with advertisements and tracking. Frost has been around [since 2017](https://github.com/AllanWang/Frost-for-Facebook/commit/f83fb56dca63a06e4706e6cb404bca9c49e5dbe0) and has been steadily growing over the years. 

Facebook, of course, was not happy with that. Some time around mid-2019, I had noticed that my account was getting locked every now and then for no rhyme or reason. Looking around on the issue board, [I was not the only one who was experiencing this.](https://github.com/AllanWang/Frost-for-Facebook/issues/1504) Facebook had started picking up Frost as a threat and started flagging accounts that were using Frost to interact with the social media. While eventually a workaround was found (which involved removing a huge chunk of the code), this still goes to show that Facebook can do whatever they want and destroy any community project that they disagree with.

Not wanting to abandon Barinsta, I continued using the client, and now here we are. My main account was banned. My alt was banned - because I don't want to comply with Facebook's invasion of privacy. There were rumors that Barinsta was coming back, but for now, it seems like a slow effort and would likely end up as a cat-and-mouse game.

## Now What?

> Neoliberal societies punish inefficiency, and teach us that it is our duty as individuals to always strive to better ourselves; if you fall behind, then it is a personal failure, rather than a failure of the system. (Badham, 2019)

I quit Instagram for now. After quitting Instagram, I do kinda miss seeing what my friends are up to, but we don't really have to limit ourselves to Instagram, do we? I've been looking into decentralized alternatives where **YOU**, the person who posts the content, owns the content. Pixelfed is one of these services that you can self-host and join other similar instances on the Fediverse. This is the best alternative the community has - but getting outsiders to join this project, is going to be hard. We need to migrate from a neoliberalism-centric society to something that allows for more freedom and something that's not built on pure capitalism.

## References

Badham, R. (2019, February 28). The neoliberal side of social media. The Badger. Retrieved October 29, 2021, from https://thebadgeronline.com/2019/03/neoliberal-side-social-media/. 
Facebook, Inc., FTC v. (District of Columbia December 9, 2020). 