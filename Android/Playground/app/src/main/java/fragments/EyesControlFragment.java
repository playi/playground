package fragments;

import android.content.res.Configuration;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.SeekBar;

import controls.ControlInterfaces;
import play_i.playground.R;
import views.EyeControlSquareView;

/**
 * Created by ilitvinenko on 3/4/15.
 * DataArt
 */
public class EyesControlFragment extends BaseFragment {

  private ControlInterfaces.IEyeControl eyeControl;
  private EyeControlSquareView eyesView;
  private SeekBar brightnessSeekBar;
  private boolean isAnimationInProgress = false;
  private LinearLayout rootLayout;

  public static EyesControlFragment newInstance(ControlInterfaces.IEyeControl control){
    EyesControlFragment result = new EyesControlFragment();
    result.eyeControl = control;
    return result;
  }

  @Override
  public void onConfigurationChanged(Configuration newConfig) {
    setRootLayoutOrientation(newConfig.orientation);
    rootLayout.invalidate();
    eyesView.invalidate();
  }

  @Override
  public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
    rootLayout = (LinearLayout) inflater.inflate(R.layout.fragment_eyes_control, container, false);

    eyesView = (EyeControlSquareView) rootLayout.findViewById(R.id.eyes_view);
    brightnessSeekBar = (SeekBar) rootLayout.findViewById(R.id.seek_bar_brightness);
    rootLayout.findViewById(R.id.button_start_eyes_show).setOnClickListener(onStartShowClickListener);
    rootLayout.findViewById(R.id.button_blink_animtion).setOnClickListener(onBlinkAnimationClickListener);

    eyesView.setDelegate(eyeControlViewDelegate);
    brightnessSeekBar.setOnSeekBarChangeListener(onBrightnessChangeListener);

    setRootLayoutOrientation(getResources().getConfiguration().orientation);

    return rootLayout;
  }

  private void setRootLayoutOrientation(int screenOrientation){
    rootLayout.setOrientation(screenOrientation == Configuration.ORIENTATION_LANDSCAPE ? LinearLayout.HORIZONTAL : LinearLayout.VERTICAL);
  }

  private EyeControlSquareView.EyeControlViewDelegate eyeControlViewDelegate = new EyeControlSquareView.EyeControlViewDelegate() {
    @Override
    public void onEyesUpdated(boolean[] values) {
      notifyStateUpdated();
    }

    @Override
    public void onShowTick() {
      int progress = brightnessSeekBar.getProgress();
      int step = brightnessSeekBar.getMax() / 10;
      int nextProgress = progress + step;
      if (nextProgress > brightnessSeekBar.getMax()){
        nextProgress = 0;
      }
      brightnessSeekBar.setProgress(nextProgress);
    }
  };

  private void notifyStateUpdated(){
    double brightness = (double)brightnessSeekBar.getProgress() / (double)brightnessSeekBar.getMax();
    eyeControl.setEyesLightAndBrightness(eyesView.getSwitchesState(), brightness);
  }

  private SeekBar.OnSeekBarChangeListener onBrightnessChangeListener = new SeekBar.OnSeekBarChangeListener() {
    @Override
    public void onProgressChanged(SeekBar seekBar, int progress, boolean fromUser) {
      notifyStateUpdated();
    }

    @Override
    public void onStartTrackingTouch(SeekBar seekBar) {

    }

    @Override
    public void onStopTrackingTouch(SeekBar seekBar) {

    }
  };

  private View.OnClickListener onStartShowClickListener = new View.OnClickListener() {
    @Override
    public void onClick(View v) {
      if (isAnimationInProgress){
        eyesView.stopShow();
        ((Button)v).setText("Start Eyes Show");
        isAnimationInProgress = false;
      } else {
        isAnimationInProgress = true;
        eyesView.startShow();
        ((Button)v).setText("Stop Eyes Show");
      }
    }
  };

  private View.OnClickListener onBlinkAnimationClickListener = new View.OnClickListener() {
    @Override
    public void onClick(View v) {
      eyeControl.startEyeBlinkAnimation();
    }
  };
}
