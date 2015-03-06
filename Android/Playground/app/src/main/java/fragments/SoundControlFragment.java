package fragments;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.SeekBar;

import com.w2.api.engine.components.sensors.Button;
import com.w2.api.engine.components.sensors.HeadPosition;
import com.w2.api.engine.constants.RobotSensorId;
import com.w2.api.engine.events.EventBusFactory;
import com.w2.api.engine.events.gesture.GestureAlertHandler;
import com.w2.api.engine.events.gesture.GestureEvent;
import com.w2.api.engine.operators.RobotSensorHistory;

import java.util.HashMap;

import controls.ControlInterfaces;
import de.greenrobot.event.EventBus;
import play_i.playground.R;

/**
 * Created by ilitvinenko on 3/5/15.
 * DataArt
 */
public class SoundControlFragment extends BaseFragment {

  private static final String ARG_HEAD_POSITION_SENSOR = "head_position";
  private static final String ARG_BUTTON_STATE_SENSOR = "button_sensor";

  private static final double PARAMETER_PAN_MIN_VALUE = -2.0;
  private static final double PARAMETER_PAN_MAX_VALUE = 2.0;

  private ControlInterfaces.ISoundControl soundControl;
  private ControlInterfaces.IRobotManagement robotManagement;
  private SeekBar volumeSeekBar;

  private GestureEvent headPositionEvent;
  private GestureEvent mainButtonChangedEvent;

  public static SoundControlFragment newInstance(ControlInterfaces.ISoundControl control, ControlInterfaces.IRobotManagement management) {
    SoundControlFragment result = new SoundControlFragment();
    result.soundControl = control;
    result.robotManagement = management;
    return result;
  }

  @Override
  public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
    View rootView = inflater.inflate(R.layout.fragment_sound_control, container, false);

    volumeSeekBar = (SeekBar) rootView.findViewById(R.id.seek_bar_volume);
    rootView.findViewById(R.id.button_play_hi).setOnClickListener(onPlayButtonClickListener);

    return rootView;
  }

  @Override
  public void onResume() {
    super.onResume();
    setupListeningEvents();
  }

  @Override
  public void onPause() {
    removeEventListener();
    super.onPause();
  }

  private void setupListeningEvents(){
    if (robotManagement.getActiveRobot() != null){
      headPositionEvent = new GestureEvent("head", robotManagement.getActiveRobot(), headPanPositionGestureHandler);
      mainButtonChangedEvent = new GestureEvent("main_button", robotManagement.getActiveRobot(), mainButtonGestureAlert);

      robotManagement.getActiveRobot().subscribeEvent(headPositionEvent);
      robotManagement.getActiveRobot().subscribeEvent(mainButtonChangedEvent);
    }
    EventBus robotBus = EventBusFactory.getRobotEventBus(robotManagement.getActiveRobot().getRobotId());
    if (robotBus != null) {
      robotBus.register(this);
    }
  }

  private void removeEventListener(){
    if (robotManagement.getActiveRobot() != null){
      robotManagement.getActiveRobot().unsubscribeEvent(headPositionEvent);
      robotManagement.getActiveRobot().unsubscribeEvent(mainButtonChangedEvent);
    }
    EventBus robotBus = EventBusFactory.getRobotEventBus(robotManagement.getActiveRobot().getRobotId());
    if (robotBus != null) {
      robotBus.unregister(this);
    }
  }

  public void onEvent(GestureEvent event){
    if (event.getIdentifier().equals(headPositionEvent.getIdentifier())){
      HeadPosition panPosition = (HeadPosition) event.getInformation().get(ARG_HEAD_POSITION_SENSOR);
      if (panPosition != null) {
        double normalizedAngle = (panPosition.getAngle() - PARAMETER_PAN_MIN_VALUE) / (PARAMETER_PAN_MAX_VALUE - PARAMETER_PAN_MIN_VALUE);
        volumeSeekBar.setProgress((int) (volumeSeekBar.getMax() * normalizedAngle));
      }
    } else if (event.getIdentifier().equals(mainButtonChangedEvent.getIdentifier())){
      int progress = volumeSeekBar.getProgress() == volumeSeekBar.getMax() ? 0 : volumeSeekBar.getMax();
      volumeSeekBar.setProgress(progress);
    }
  }

  private View.OnClickListener onPlayButtonClickListener = new View.OnClickListener() {
    @Override
    public void onClick(View v) {
      double volume = (double)volumeSeekBar.getProgress() / (double)volumeSeekBar.getMax();
      soundControl.playHiSound(volume);

    }
  };

  private GestureAlertHandler headPanPositionGestureHandler = new GestureAlertHandler() {
    @Override
    public boolean shouldAlert(GestureEvent gestureEvent, RobotSensorHistory robotSensorHistory) {
      HeadPosition currentPanPosition = (HeadPosition) robotSensorHistory.getCurrentState().getSensor(RobotSensorId.HEAD_POSITION_PAN);
      HeadPosition previousPanPosition = (HeadPosition) robotSensorHistory.getPreviousState().getSensor(RobotSensorId.HEAD_POSITION_PAN);

      if (currentPanPosition == null || previousPanPosition == null) return false;

      boolean shouldTrigger = Math.abs(currentPanPosition.getAngle() - previousPanPosition.getAngle()) > 0.05;

      if (shouldTrigger){
        HashMap<String, Object> parameters = new HashMap<>();
        parameters.put(ARG_HEAD_POSITION_SENSOR, currentPanPosition);
        gestureEvent.setInformation(parameters);
      }

      return shouldTrigger;
    }
  };

  private GestureAlertHandler mainButtonGestureAlert = new GestureAlertHandler() {
    @Override
    public boolean shouldAlert(GestureEvent gestureEvent, RobotSensorHistory robotSensorHistory) {
      Button mainButtonCurrent = (Button) robotSensorHistory.getCurrentState().getSensor(RobotSensorId.BUTTON_MAIN);
      Button mainButtonPrev = (Button) robotSensorHistory.getPreviousState().getSensor(RobotSensorId.BUTTON_MAIN);
      boolean shouldTrigger = (mainButtonCurrent.isPressed() != mainButtonPrev.isPressed()) && mainButtonCurrent.isPressed() == false ;

      if (shouldTrigger){
        HashMap<String, Object> parameters = new HashMap<>();
        parameters.put(ARG_BUTTON_STATE_SENSOR, mainButtonCurrent);
        gestureEvent.setInformation(parameters);
      }

      return shouldTrigger;
    }
  };
}
