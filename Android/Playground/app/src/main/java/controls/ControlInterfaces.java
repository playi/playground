package controls;

import com.w2.api.engine.robots.Robot;

import java.util.HashMap;

/**
 * Created by ilitvinenko on 3/4/15.
 * DataArt
 */
public interface ControlInterfaces {

  interface IRobotManagement {
    public Robot getActiveRobot();
    public void setActiveRobot(Robot activeRobot);
  }

  interface ILightsControl {
    public void setLeftEarColor(double red, double green, double blue);
    public void setRightEarColor(double red, double green, double blue);
    public void setChestColor(double red, double green, double blue);
    public void setMainButtonBrightness(double brightness);
    public void setTailBrightness(double brightness);
  }

  interface IEyeControl {
    public void setEyesLightAndBrightness(boolean[] states, double brightness);
    public void startEyeBlinkAnimation();
  }

  interface IWheelControl {
    public void setWheelAttributes(double linear, double angle);
    public void playWiggleAnimation();
    public void playNodAnimation();
  }

  interface IHeadControl {
    public void setHeadPosition(double tilt, double pan);
  }

  interface ISoundControl {
    public void playHiSound(double volume);
  }

  interface ISensorsDataSource {
    public HashMap<String, String> getRobotSensorsData();
  }
}
