package controls;

import android.app.Activity;
import android.content.Context;

import com.w2.api.engine.components.commands.BodyWheels;
import com.w2.api.engine.components.commands.EyeRing;
import com.w2.api.engine.components.commands.HeadPosition;
import com.w2.api.engine.components.commands.LightMono;
import com.w2.api.engine.components.commands.LightRGB;
import com.w2.api.engine.components.commands.Speaker;
import com.w2.api.engine.components.sensors.Accelerometer;
import com.w2.api.engine.components.sensors.Button;
import com.w2.api.engine.components.sensors.Distance;
import com.w2.api.engine.components.sensors.Encoder;
import com.w2.api.engine.components.sensors.Gyroscope;
import com.w2.api.engine.components.sensors.Microphone;
import com.w2.api.engine.constants.RobotSensorId;
import com.w2.api.engine.constants.RobotType;
import com.w2.api.engine.operators.CommandSetSequence;
import com.w2.api.engine.operators.RobotCommandSet;
import com.w2.api.engine.operators.RobotSensorHistory;
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
import java.util.HashMap;
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
                                     ControlInterfaces.ISoundControl,
                                     ControlInterfaces.ISensorsDataSource{

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

  @Override
  public HashMap<String, String> getRobotSensorsData() {
    if (!isActiveRobotAvailable()) return new HashMap<>();

    HashMap<String, String> result = new HashMap<>();

    RobotSensorHistory sensorHistory = activeRobot.getHistory();

    result.put("Name", activeRobot.getName());

    Button mainButton = (Button) sensorHistory.getCurrentState().getSensor(RobotSensorId.BUTTON_MAIN);
    Button button1 = (Button) sensorHistory.getCurrentState().getSensor(RobotSensorId.BUTTON_1);
    Button button2 = (Button) sensorHistory.getCurrentState().getSensor(RobotSensorId.BUTTON_2);
    Button button3 = (Button) sensorHistory.getCurrentState().getSensor(RobotSensorId.BUTTON_3);

    result.put("Button Main", String.valueOf(mainButton.isPressed()));
    result.put("Button 1", String.valueOf(button1.isPressed()));
    result.put("Button 2", String.valueOf(button2.isPressed()));
    result.put("Button 3", String.valueOf(button3.isPressed()));

    Accelerometer accelerometer = (Accelerometer) sensorHistory.getCurrentState().getSensor(RobotSensorId.ACCELEROMETER);
    result.put("Accelerometer", String.format("X: %3.2f, Y: %3.2f, Z: %3.2f", accelerometer.getX(), accelerometer.getY(), accelerometer.getZ()));

    Microphone microphone = (Microphone) sensorHistory.getCurrentState().getSensor(RobotSensorId.MICROPHONE);
    result.put("Microphone", String.format("Amplitude: %03f, Angle %3.2f degrees", microphone.getAmplitude(), Math.toDegrees(microphone.getTriangulationAngle())));

    if (activeRobot.getRobotType() == RobotType.DASH){
      Distance distanceFlf = (Distance) sensorHistory.getCurrentState().getSensor(RobotSensorId.DISTANCE_FRONT_LEFT_FACING);
      Distance distanceFrf = (Distance) sensorHistory.getCurrentState().getSensor(RobotSensorId.DISTANCE_FRONT_RIGHT_FACING);
      Distance distanceRrf = (Distance) sensorHistory.getCurrentState().getSensor(RobotSensorId.DISTANCE_BACK);

      result.put("Distance", String.format("Left-Facing: %2.2f, Dist Right-Facing: %2.2f, Dist Tail: %2.2f", distanceFlf.getReflectance(), distanceFrf.getReflectance(), distanceRrf.getReflectance()));

      Gyroscope gyroscope = (Gyroscope) sensorHistory.getCurrentState().getSensor(RobotSensorId.GYROSCOPE);
      result.put("Gyroscope", String.format("yaw: %3.2f, pitch: %3.2f, roll: %3.2f", gyroscope.getX(), gyroscope.getY(), gyroscope.getZ()));

      com.w2.api.engine.components.sensors.HeadPosition headPositionPan = (com.w2.api.engine.components.sensors.HeadPosition) sensorHistory.getCurrentState().getSensor(RobotSensorId.HEAD_POSITION_PAN);
      com.w2.api.engine.components.sensors.HeadPosition headPositionTilt = (com.w2.api.engine.components.sensors.HeadPosition) sensorHistory.getCurrentState().getSensor(RobotSensorId.HEAD_POSITION_TILT);
      result.put("Head", String.format("Pan: %3.2f degrees, Tilt: %3.2f degrees", Math.toDegrees(headPositionPan.getAngle()), Math.toDegrees(headPositionTilt.getAngle())));

      Encoder encoderLw = (Encoder) sensorHistory.getCurrentState().getSensor(RobotSensorId.ENCODER_LEFT_WHEEL);
      Encoder encoderRw = (Encoder) sensorHistory.getCurrentState().getSensor(RobotSensorId.ENCODER_RIGHT_WHEEL);
      result.put("Encoder", String.format("Left: %4.2f cm, Right: %4.2f cm", encoderLw.getDistance(), encoderRw.getDistance()));

    }

    return result;
  }
}
