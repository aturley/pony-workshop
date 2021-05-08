# For Presenters

This workshop is designed to help people learn how to start using Pony. It is based on lessons learned from teaching Pony and watching people learn Pony on their own. It is not meant to be comprehensive, rather it is intended to give participants the confidence to start writing their own Pony programs.

## Before the Workshop

### Workshop Announcement

The following copy can be used to announce and advertise the workshop:

> Join us for a hands-on workshop led by YOUR NAME. Learn [Pony](https://www.ponylang.org/), a fast actor-based programming language which guarantees that programs will not have data races.
>
> This workshop will teach participants about some of Pony’s core ideas and patterns by having them write a series of small programs that culminate in a simple chat server. Topics covered will include Pony’s actor system, reference capabilities, and working with the compiler.
> Please Note:
>
> Make sure to bring a laptop with the following software installed: the [Pony compiler](https://github.com/ponylang/ponyc/blob/main/INSTALL.md), and a telnet client. Also clone the [workshop git repository](https://github.com/aturley/pony-workshop).

You will probably want to limit the number of participants to around 20. Any more than that and things will likely become chaotic.

### Workspace Preparation

The space required for the workshop may vary depending on how exactly you want to run it, but here are my suggestions:

* Enough chairs and enough table space for people to sit with laptops
  * Ideally everyone would sit around a large table, in close enough proximity that they can hear each other's questions and answers
* Enough power outlets to keep everyone's laptop from dying
* An internet connection for each participant
* A large screen to display slides and programs

### Things to Bring

* Laptop with:
  * `ponyc`
  * a telnet client
  * a clone of the Pony workshop repo
* Printed copies of the [Pony Cheatsheet](https://www.ponylang.org/media/cheatsheet/pony-cheat-sheet.pdf) for all of the participants
* Pony stickers

## Workshop Schedule

The workshop can be done in about 2.5 hours. If you have less than 2.5 hours you will probably run out of time somewhere.

### Participant Setup (15 minutes)

Make sure everyone has a working copy of the Pony compiler and telnet, help anyone who doesn't. Expect that at least a few people will not have things set up correctly when they arrive.

### Introductory Presentation (15 minutes)

Do the introductory presentation. The source for the presentation is in `PITCHME.md`, the presentation can be rendered here [here](https://gitpitch.com/aturley/pony-workshop/master) (if you have created your own fork then you will need to change the URL, but you don't need to set up an account on Gitpitch).

The purpose of the presentation is to help participants understand what's special about Pony and help them form a mental model of what's happening when a Pony program runs. This is based on the idea of a "notional machine", which is described in the paper [Programming Paradigms and Beyond](https://cs.brown.edu/~sk/Publications/Papers/Published/kf-prog-paradigms-and-beyond/paper.pdf). Providing a common notional machine should help participants understand concepts more quickly than leaving them to develop their own notional machine.

### Step 01 - Step 04 (30 minutes each)

The presenter should encourage participants to open the README for the step, as well as the code. The presenter should then talk about what is happening in the program in a way that roughly follows what is covered in the README.

The presenter is discouraged from presenting ideas that are outside of what is covered in the step's README unless they are responding to a question from a participant. This will help keep the discussion focused.

I usually start by showing the code and describing what the program should do, then compiling and running the program, then going back to the code and talking about the different parts. I keep the code open in an editor so that I can highlight parts as I talk. I don't have any slides specific to the steps because I think it's important to keep the code up, and if people want to read about it they can look at the README.

I allow questions at any point.

Once you've gone through the code you can solicit followup questions. If noone has any questions and you still have time you can make suggestions for how the participants might modify the program to generate errors that help clarify what's going on (for example, change the reference capability of an alias).
