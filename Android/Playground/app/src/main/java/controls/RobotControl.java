package controls;

import android.app.Activity;
import android.content.Context;

import com.w2.api.engine.components.commands.BodyWheels;
import com.w2.api.engine.components.commands.EyeRing;
import com.w2.api.engine.components.commands.HeadPosition;
import com.w2.api.engine.components.commands.LightMono;
import com.w2.api.engine.components.commands.LightRGB;
import com.w2.api.engine.components.commands.Speaker;
import com.w2.api.engine.operators.CommandSetSequence;
import com.w2.api.engine.operators.RobotCommandSet;
import com.w2.api.engine.robots.Robot;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.io.StringWriter;
import java.io.Writer;
import java.lang.ref.WeakReference;
import java.util.Hashtable;

import play_i.playground.R;

/**
 * Created by ilitvinenko on 3/4/15.
 * DataArt
 */
public class RobotControl implements ControlInterfaces.IRobotManagement,
                                     ControlInterfaces.ILightsControl,
                                     ControlInterfaces.IEyeControl,
                                     ControlInterfaces.IWheelControl,
                                     ControlInterfaces.IHeadControl,
ControlInterfaces.ISoundControl{

  private Robot activeRobot;
  private Hashtable<Integer, JSONObject> cachedAnimations = new Hashtable<>();
  private WeakReference<Activity> holder;

  public Robot getActiveRobot() {
    return activeRobot;
  }

  public void setActiveRobot(Robot activeRobot) {
    this.activeRobot = activeRobot;
  }

  private boolean isActiveRobotAvailable(){
    return (activeRobot != null && activeRobot.isConnected());
  }

  public void setHolder(Activity activity){
    holder = new WeakReference<Activity>(activity);
  }

  private JSONObject loadAnimationWithId(int resourceId){
    JSONObject animation = cachedAnimations.get(resourceId);
    if (animation == null) {
      try {
        String jsonString = loadJsonStringFromFile(holder.get(), resourceId);
        animation = new JSONObject(jsonString);
        cachedAnimations.put(resourceId, animation);
      } catch (IOException e) {
        e.printStackTrace();
      } catch (JSONException e) {
        e.printStackTrace();
      }
    }
    return animation;
  }

  private String loadJsonStringFromFile(Context context, int resourceId) throws IOException {
    if (context == null) { return "";  }

    InputStream is = context.getResources().openRawResource(resourceId);
    Writer writer = new StringWriter();
    char[] buffer = new char[1024];
    try {
      Reader reader = new BufferedReader(new InputStreamReader(is, "UTF-8"));
      int n;
      while ((n = reader.read(buffer)) != -1) {
        writer.write(buffer, 0, n);
      }
    } finally {
      is.close();
    }

    return writer.toString();
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

  @Override
  public void setEyesLightAndBrightness(boolean[] states, double brightness) {
    if (!isActiveRobotAvailable()) return;

    RobotCommandSet commandSet = RobotCommandSet.emptySet();
    commandSet.addCommandEyeRing(new EyeRing(brightness, states));
    activeRobot.sendCommandSet(commandSet);
  }

  @Override
  public void startEyeBlinkAnimation() {
    if (!isActiveRobotAvailable()) return;

    RobotCommandSet commandSet = RobotCommandSet.emptySet();
    commandSet.addCommandEyeRing(new EyeRing(EyeRing.EYEANIM_FULL_BLINK_FILE));
    activeRobot.sendCommandSet(commandSet);
  }

  @Override
  public void setWheelAttributes(double linear, double angle) {
    if (!isActiveRobotAvailable()) return;

    RobotCommandSet commandSet = RobotCommandSet.emptySet();
    commandSet.addCommandBodyWheels(new BodyWheels(linear, angle));
    activeRobot.sendCommandSet(commandSet);
  }

  @Override
  public void playWiggleAnimation() {
    if (!isActiveRobotAvailable()) return;
    CommandSetSequence commandSetSequence = new CommandSetSequence();
    commandSetSequence.fromJson(loadAnimationWithId(R.raw.wiggle));
    activeRobot.startCommandSetSequence(commandSetSequence);
  }

  @Override
  public void playNodAnimation() {
    if (!isActiveRobotAvailable()) return;

    RobotCommandSet commandSet = RobotCommandSet.emptySet();
    commandSet.addCommandHeadPositionTilt(new HeadPosition(-20));
    commandSet.addCommandHeadPositionTilt(new HeadPosition(7.5));
    commandSet.addCommandHeadPositionTilt(new HeadPosition(-20));
    commandSet.addCommandHeadPositionTilt(new HeadPosition(7.5));
    activeRobot.sendCommandSet(commandSet);
  }

  @Override
  public void setHeadPosition(double tilt, double pan) {
    if (!isActiveRobotAvailable()) return;

    RobotCommandSet commandSet = RobotCommandSet.emptySet();
    commandSet.addCommandHeadPositionTiltAndPan(new HeadPosition(tilt), new HeadPosition(pan));
    activeRobot.sendCommandSet(commandSet);
  }

  @Override
  public void playHiSound(double volume) {
    if (!isActiveRobotAvailable()) return;

    RobotCommandSet commandSet = RobotCommandSet.emptySet();
    commandSet.addCommandSound(new Speaker(Speaker.SOUNDFILE_HI, volume));
    activeRobot.sendCommandSet(commandSet);
  }
}
