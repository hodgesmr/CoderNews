# CoderNews
### A simple reader for Hacker News and Reddit Programming

CoderNews is a simple iOS application for aggregating and reading articles from [Hacker News](http://news.ycombinator.com) and [Reddit Programming](http://reddit.com/r/programming). While there are many alternative applications available to consume this content, CoderNews was designed to keep things minimalistic. Often it is too hard to try to read and submit comments, or vote on stories, from the confines of a hand-held device. CoderNews strives to give you what you want: fresh content that is easy to read.

## Contribute

There were many reasons to make CoderNews open source. One is that I used many open source libraries and modules while making the applicaiton. I felt it only right to contribute back to the open source community by making the code and assets of CoderNews open and licensed under the MIT License.

The other reason for making CoderNews open source is that I know there is room for improvement. This project began like so many projects do: I was simply playing around with an idea one night, and the next thing I know I've got an app. That being said, there are many ways in which CoderNews can be improved. I'll admit it: some of the code is hacky. And the UI isn't the greatest (I'll be the first to admit that I'm no designer). So what better way to allow CoderNews to improve than let the community contribute?

The master branch reflects the most up-to-date codebase for CoderNews. The associated tags reflect the various App Store submissions. Update your tags regularly, as they may change if Apple doesn't like a given submission.

### Pocket API Key

CoderNews implements the [Pocket SDK for iOS](https://github.com/Pocket/Pocket-ObjC-SDK) as a submodule. One of the requirements for the Pocket SDK is that each developer has a unique and secret API key. CoderNews contains the file **Keys.h** which is committed with a dummy key. If you wish to fork CoderNews, be sure to replace that dummy key with your own Pocket API key. Note: **.gitignore** is set to not track this file; adjust that as necessary.

## FAQs

### How is CoderNews different from other Hacker News / Reddit apps?

CoderNews was intentionally designed to be simple and minimal. You won't find features such as comment threads or the ability vote on stories. Historically, these features are hard to use on small devices and I want to make an app that is easy to use.

### How is the content ordered?

Often, Hacker News and Reddit will keep stories at the top of the page for a long time. I call these *stale* stories. CoderNews works to show you fresh content. Stories are in semi-chronological order, with newer front-page stories appearing at the top of the news list.

### Why don't some stories show up?

CoderNews isn't meant to be a mirror of Hacker News or Reddit Programming. I'm pruning out stories that don't *make the cut*. There are point thresholds and content-type filters.

### Why isn't CoderNews optimized for the iPad?

Short answer: I don't own an iPad so development is challenging. However, feel free to fork and contribute!

### I'm a designer, not a developer. Can I contribute?

Absolutely! I hope that the look, feel, and experiences of CoderNews will evolve into something beautiful. Designers are welcome to propose new assets or even submit mockups for better layouts.

### Couldn't I do all this with RSS?

Yeah, probably.

## A Matt Hodges project

This project is maintained by [@hodgesmr](http://twitter.com/hodgesmr).
