# Play-i API documentation
Welcome to Play-i API!  In this repository, you will have access to the code and examples that will help you understand how to control Bo/Yana as well as react to its sensory data.  Since the API is still in the alpha stage, please expect many changes in the upcoming weeks!  Whenever we update the API, we will denote the changes and goals in the "status & summary" section.


### Status & summary
API phase: **ALPHA** (v0.1)

The goals of this version of the API are as follows:
1. Publish the initial architecture of the API to get design feedback
2. Collect actionable feedback for how to improve documentation
3. Lock on the API signature definitions for v1.0
4. Gather any API usage improvement features

Next major milestone: ~4/14
- Entire API package (not just header files) with installation instructions
- User authentication/authorization feature
- Developer simulator that can be run on a 2nd iPad to program against
- Official bug tracking process to resolve any API related issues


### API features
For this version of the API, we are only releasing the header files as we are still flushing out designs and bugs at this moment.  With that said, the header files describe the following features:
- Discovery and connection management of play-i robots through *PIRobotManager*
- Issuing commands and accessing sensor values through *PIRobot*

The following sub-sections goes more into details.

#### Discovery/Connection management of play-i robots
Before issuing commands to the play-i robots, we need to first discover and connect to them.  *PIRobotManager* class handles the heavy lifting by making it easy to:
- Scan for play-i robots that is available to connect to
- Establish connection (and disconnect) with robot 
- Caching known robots and its connection status

All of the calls above are asynchronous and results will be handled by *PIRobotManagerDelegate*.

In the future, *PIRobotManager* will also handle:
- Account authentication/authorization
- System level errors (battery, connection interruptions)
- Performance optimizations (process queues, async request)

#### Issuing commands to play-i robots
There are two ways to issue commands to robots, and both are done through *PIRobot* object.  All command calls are "fire-and-forget", non-blocking calls. 

##### Single command through PIComponentStates
The easiest way to issue a command to a robot is through the use of *PIComponentStates*.  This is a simple object 
- Setting robot output actuator values using *PIComponentStates*.  
- Executing a sequence of actions by sending *PICommandSequence* values 

When setting the actuator values through 

- Notification callback on robot sensors through registration of PIEvent to PIRobot

- Execute a sequence of instructions (with its own notifications) with the use of PICommandSequence

### Changelog
3/17/2014 - Initial alpha release (v0.1) with header files only

