package controls;

import com.w2.api.engine.components.commands.LightMono;
import com.w2.api.engine.components.commands.LightRGB;
import com.w2.api.engine.operators.RobotCommandSet;
import com.w2.api.engine.robots.Robot;

/**
 * Created by ilitvinenko on 3/4/15.
 * DataArt
 */
public class RobotControl implements ControlInterfaces.IRobotManagement,
                                     ControlInterfaces.ILightsControl,
                                     ControlInterfaces.IEyeControl {

  private Robot activeRobot;

  public Robot getActiveRobot() {
    return activeRobot;
  }

  public void setActiveRobot(Robot activeRobot) {
    this.activeRobot = activeRobot;
  }

  private boolean isActiveRobotAvailable(){
    return (activeRobot != null && activeRobot.isConnected());
  }

  @Override
  public void setLeftEarColor(double red, double green, double blue) {
    if (!isActiveRobotAvailable()) return;

    RobotCommandSet commandSet = RobotCommandSet.emptySet();
    commandSet.addCommandLeftEarLight(new LightRGB(red, green, blue));
    activeRobot.sendCommandSet(commandSet);
  }

  @Override
  public void setRightEarColor(double red, double green, double blue) {
    if (!isActiveRobotAvailable()) return;

    RobotCommandSet commandSet = RobotCommandSet.emptySet();
    commandSet.addCommandRightEarLight(new LightRGB(red, green, blue));
    activeRobot.sendCommandSet(commandSet);
  }

  @Override
  public void setChestColor(double red, double green, double blue) {
    if (!isActiveRobotAvailable()) return;

    RobotCommandSet commandSet = RobotCommandSet.emptySet();
    commandSet.addCommandChestLight(new LightRGB(red, green, blue));
    activeRobot.sendCommandSet(commandSet);
  }

  @Override
  public void setMainButtonBrightness(double brightness) {
    if (!isActiveRobotAvailable()) return;

    RobotCommandSet commandSet = RobotCommandSet.emptySet();
    commandSet.addCommandMainButtonLight(new LightMono(brightness));
    activeRobot.sendCommandSet(commandSet);
  }

  @Override
  public void setTailBrightness(double brightness) {
    if (!isActiveRobotAvailable()) return;

    RobotCommandSet commandSet = RobotCommandSet.emptySet();
    commandSet.addCommandTailLight(new LightMono(brightness));
    activeRobot.sendCommandSet(commandSet);
  }
}
