package fragments;

import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.support.annotation.Nullable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.SeekBar;

import controls.ControlInterfaces;
import play_i.playground.R;

/**
 * Created by ilitvinenko on 3/4/15.
 * DataArt
 */
public class LightsControlFragment extends BaseFragment {

  private static int[] leftEarIds = new int[]{R.id.left_ear_r, R.id.left_ear_g, R.id.left_ear_b};
  private static int[] rightEarIds = new int[]{R.id.right_ear_r, R.id.right_ear_g, R.id.right_ear_b};
  private static int[] chestIds = new int[]{R.id.chest_r, R.id.chest_g, R.id.chest_b};
  private static int mainButtonBrightness = R.id.main_button_brightness;
  private static int tailBrightness = R.id.back_brightness;
  private static int ANIMATION_DELAY = 1000; //1 sec


  private ControlInterfaces.ILightsControl lightsControl;
  private SeekBar[] leftEarSeekBars;
  private SeekBar[] rightEarSeekBars;
  private SeekBar[] chestSeekBars;
  private SeekBar mainButtonBrightnessSeekBar;
  private SeekBar backButtonBrightnessSeekBar;

  private Handler lightsShowHandler = new Handler(Looper.getMainLooper());
  private boolean isLightsShowInAction = false;

  public static LightsControlFragment newInstance(ControlInterfaces.ILightsControl lightsControl) {
    LightsControlFragment result = new LightsControlFragment();
    result.lightsControl = lightsControl;
    return result;
  }

  @Override
  public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
    View rootView = inflater.inflate(R.layout.fragment_lights_control, container, false);

    rootView.findViewById(R.id.button_start_lights_show).setOnClickListener(onStartShowClickListener);
    setupSeekBars(rootView);

    return rootView;
  }

  @Override
  public void onPause() {
    stopLightsShow();
    super.onPause();
  }

  private void setupSeekBars(View rootView) {
    leftEarSeekBars = getSeekBarsForIds(rootView, leftEarIds, onLeftEarSeekBarProgress);
    rightEarSeekBars = getSeekBarsForIds(rootView, rightEarIds, onRightEarSeekBarProgress);
    chestSeekBars = getSeekBarsForIds(rootView, chestIds, onChestSeekBarProgress);
    mainButtonBrightnessSeekBar = (SeekBar) rootView.findViewById(mainButtonBrightness);
    backButtonBrightnessSeekBar = (SeekBar) rootView.findViewById(tailBrightness);

    mainButtonBrightnessSeekBar.setOnSeekBarChangeListener(onMainButtonSeekBarProgress);
    backButtonBrightnessSeekBar.setOnSeekBarChangeListener(onBackButtonSeekBarProgress);
  }

  private void startLightsShow() {
    isLightsShowInAction = true;
    sendCurrentSettingsAndScheduleNextOne(0, ANIMATION_DELAY);
  }

  private void stopLightsShow() {
    lightsShowHandler.removeCallbacksAndMessages(null);
    isLightsShowInAction = false;
  }

  private void sendCurrentSettingsAndScheduleNextOne(int startIndex, final int delay){
    final int index = startIndex % 4;
    generateNewColorValuesAndSendToRobot(index);
    lightsShowHandler.postDelayed(new Runnable() {
      @Override
      public void run() {
        sendCurrentSettingsAndScheduleNextOne(index + 1, delay);
      }
    }, delay);
  }

  private void generateNewColorValuesAndSendToRobot(int step) {
    double r, g, b, mono;

    switch (step) {
      case 0:
        r = 1.0; g = 0; b = 0; mono = 1.0;
        break;
      case 1:
        r = 0; g = 1.0; b = 0; mono = 0.5;
        break;
      case 2:
        r = 0; g = 0; b = 1.0; mono = 0;
        break;
      case 3:
        r = 0.5; g = 0.5; b = 0.5; mono = 0.75;
        break;
      default:
        r = 0; g = 0; b = 0; mono = 0;
        break;
    }

    updateSlidersToValues(r, g, b, mono);

    lightsControl.setLeftEarColor(r, g, b);
    lightsControl.setRightEarColor(r, g, b);
    lightsControl.setChestColor(r, g, b);
    lightsControl.setMainButtonBrightness(mono);
    lightsControl.setTailBrightness(mono);
  }

  private void updateSlidersToValues(double r, double g, double b, double mono){
    updateSeekBar(leftEarSeekBars[0], r);
    updateSeekBar(leftEarSeekBars[1], g);
    updateSeekBar(leftEarSeekBars[2], b);

    updateSeekBar(rightEarSeekBars[0], r);
    updateSeekBar(rightEarSeekBars[1], g);
    updateSeekBar(rightEarSeekBars[2], b);

    updateSeekBar(chestSeekBars[0], r);
    updateSeekBar(chestSeekBars[1], g);
    updateSeekBar(chestSeekBars[2], b);

    updateSeekBar(mainButtonBrightnessSeekBar, mono);
    updateSeekBar(backButtonBrightnessSeekBar, mono);
  }

  private void updateSeekBar(SeekBar bar, double value){
    int result = (int) (bar.getMax() * value);
    bar.setProgress(result);
  }

  private double getNormalizesValue(SeekBar seekBar){
    double result = (double)seekBar.getProgress() / (double)seekBar.getMax();
    return result;
  }

  private SeekBar[] getSeekBarsForIds(View rootView, int[] ids, SeekBar.OnSeekBarChangeListener listener) {
    SeekBar[] results = new SeekBar[ids.length];

    for (int i = 0; i < ids.length; i++) {
      results[i] = (SeekBar) rootView.findViewById(ids[i]);
      results[i].setOnSeekBarChangeListener(listener);
    }
    return results;
  }

  private View.OnClickListener onStartShowClickListener = new View.OnClickListener() {
    @Override
    public void onClick(View v) {
      if (isLightsShowInAction) {
        stopLightsShow();
        ((Button) v).setText("Start Lights Show");
      } else {
        startLightsShow();
        ((Button) v).setText("Stop Lights Show");
      }
    }
  };

  private SeekBar.OnSeekBarChangeListener onChestSeekBarProgress = new SeekBar.OnSeekBarChangeListener() {
    @Override
    public void onProgressChanged(SeekBar seekBar, int progress, boolean fromUser) {
      if (isLightsShowInAction) return;

      double r = getNormalizesValue(chestSeekBars[0]);
      double g = getNormalizesValue(chestSeekBars[1]);
      double b = getNormalizesValue(chestSeekBars[2]);

      lightsControl.setChestColor(r, g, b);
    }

    @Override
    public void onStartTrackingTouch(SeekBar seekBar) {

    }

    @Override
    public void onStopTrackingTouch(SeekBar seekBar) {

    }
  };

  private SeekBar.OnSeekBarChangeListener onRightEarSeekBarProgress = new SeekBar.OnSeekBarChangeListener() {
    @Override
    public void onProgressChanged(SeekBar seekBar, int progress, boolean fromUser) {
      if (isLightsShowInAction) return;

      double r = getNormalizesValue(rightEarSeekBars[0]);
      double g = getNormalizesValue(rightEarSeekBars[1]);
      double b = getNormalizesValue(rightEarSeekBars[2]);

      lightsControl.setRightEarColor(r, g, b);
    }

    @Override
    public void onStartTrackingTouch(SeekBar seekBar) {

    }

    @Override
    public void onStopTrackingTouch(SeekBar seekBar) {

    }
  };

  private SeekBar.OnSeekBarChangeListener onLeftEarSeekBarProgress = new SeekBar.OnSeekBarChangeListener() {
    @Override
    public void onProgressChanged(SeekBar seekBar, int progress, boolean fromUser) {
      if (isLightsShowInAction) return;

      double r = getNormalizesValue(leftEarSeekBars[0]);
      double g = getNormalizesValue(leftEarSeekBars[1]);
      double b = getNormalizesValue(leftEarSeekBars[2]);

      lightsControl.setLeftEarColor(r, g ,b);
    }

    @Override
    public void onStartTrackingTouch(SeekBar seekBar) {

    }

    @Override
    public void onStopTrackingTouch(SeekBar seekBar) {

    }
  };

  private SeekBar.OnSeekBarChangeListener onMainButtonSeekBarProgress = new SeekBar.OnSeekBarChangeListener() {
    @Override
    public void onProgressChanged(SeekBar seekBar, int progress, boolean fromUser) {
      if (isLightsShowInAction) return;

      lightsControl.setMainButtonBrightness(getNormalizesValue(seekBar));
    }

    @Override
    public void onStartTrackingTouch(SeekBar seekBar) {

    }

    @Override
    public void onStopTrackingTouch(SeekBar seekBar) {

    }
  };

  private SeekBar.OnSeekBarChangeListener onBackButtonSeekBarProgress = new SeekBar.OnSeekBarChangeListener() {
    @Override
    public void onProgressChanged(SeekBar seekBar, int progress, boolean fromUser) {
      if (isLightsShowInAction) return;

      lightsControl.setTailBrightness(getNormalizesValue(seekBar));
    }

    @Override
    public void onStartTrackingTouch(SeekBar seekBar) {

    }

    @Override
    public void onStopTrackingTouch(SeekBar seekBar) {

    }
  };
}
