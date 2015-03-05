package fragments;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.SeekBar;

import com.w2.api.engine.events.gesture.GestureAlertHandler;
import com.w2.api.engine.events.gesture.GestureEvent;
import com.w2.api.engine.operators.RobotSensorHistory;

import controls.ControlInterfaces;
import play_i.playground.R;

/**
 * Created by ilitvinenko on 3/5/15.
 * DataArt
 */
public class SoundControlFragment extends BaseFragment {

  private ControlInterfaces.ISoundControl soundControl;
  private ControlInterfaces.IRobotManagement robotManagement;
  private SeekBar volumeSeekBar;

  private GestureEvent headPositionEvent;

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
      robotManagement.getActiveRobot().subscribeEvent(headPositionEvent);
    }
  }

  private void removeEventListener(){
    if (robotManagement.getActiveRobot() != null){
      robotManagement.getActiveRobot().unsubscribeEvent(headPositionEvent);
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
      //TODO: It's not clear how should it works
      return true;
    }
  };

  private GestureAlertHandler onMainButtonTouchedGestureHandler = new GestureAlertHandler() {
    @Override
    public boolean shouldAlert(GestureEvent gestureEvent, RobotSensorHistory robotSensorHistory) {
      int progress = volumeSeekBar.getProgress();
      if (progress == 0){
        progress = volumeSeekBar.getMax();
      } else {
        progress = 0;
      }
      volumeSeekBar.setProgress(progress);
      //TODO: Or false??
      return true;
    }
  };
}
