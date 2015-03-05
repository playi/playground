package views;

import android.content.Context;
import android.content.res.Configuration;
import android.content.res.TypedArray;
import android.graphics.Point;
import android.os.Handler;
import android.os.Looper;
import android.util.AttributeSet;
import android.util.TypedValue;
import android.view.Display;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.CompoundButton;
import android.widget.FrameLayout;
import android.widget.Switch;

import com.w2.logging.LoggingHelper;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by ilitvinenko on 3/5/15.
 * DataArt
 */
public class EyeControlSquareView extends SquareFrameLayout {

  public interface EyeControlViewDelegate {
    public void onEyesUpdated(boolean[] values);

    public void onShowTick();
  }

  private static final int EYES_COUNT = 12;
  private static final int SHOW_PERIOD = 400; // 0.4sec

  private List<Switch> eyesSwitches = new ArrayList<>(EYES_COUNT);
  private EyeControlViewDelegate delegate;
  private Handler showHandler = new Handler(Looper.getMainLooper());

  public EyeControlSquareView(Context context) {
    super(context);
    initialize();
  }

  public EyeControlSquareView(Context context, AttributeSet attrs) {
    super(context, attrs);
    initialize();
  }

  public EyeControlSquareView(Context context, AttributeSet attrs, int defStyleAttr) {
    super(context, attrs, defStyleAttr);
    initialize();
  }

  public void setDelegate(EyeControlViewDelegate delegate) {
    this.delegate = delegate;
  }

  public void startShow() {
    for (int i = 0; i < eyesSwitches.size(); i++) {
      eyesSwitches.get(i).setChecked(i % 2 == 0);
    }
    updateSwitchesAndSendToRobot();
  }

  public void stopShow() {
    showHandler.removeCallbacksAndMessages(null);
  }

  public void setEyesSwitchesState(boolean[] state) {
    if (state.length != eyesSwitches.size()) return;
    for (int i = 0; i < state.length; i++) {
      eyesSwitches.get(i).setChecked(state[i]);
    }
  }

  public boolean[] getSwitchesState() {
    return pickStateFromSwitches();
  }

  private void updateSwitchesAndSendToRobot() {
    if (delegate != null) {
      delegate.onShowTick();
    }
    for (Switch sw : eyesSwitches) {
      sw.setChecked(!sw.isChecked());
    }

    if (delegate != null) {
      delegate.onEyesUpdated(pickStateFromSwitches());
    }

    showHandler.postDelayed(new Runnable() {
      @Override
      public void run() {
        updateSwitchesAndSendToRobot();
      }
    }, SHOW_PERIOD);
  }

  private boolean[] pickStateFromSwitches() {
    boolean[] result = new boolean[eyesSwitches.size()];

    for (int i = 0; i < eyesSwitches.size(); i++) {
      result[i] = eyesSwitches.get(i).isChecked();
    }
    return result;
  }

  private void initialize() {
    generateSwitchesAndAddToView();
  }

  private void generateSwitchesAndAddToView() {
    removeSwitchesFromView();
    double rotationAngleStep = 2 * Math.PI / EYES_COUNT;
    int marginTopOffset = (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 20, getResources().getDisplayMetrics());
    int radius = (int) (this.getMeasuredWidth() / 2);

    if (radius <= 0) {
      WindowManager wm = (WindowManager) getContext().getSystemService(Context.WINDOW_SERVICE);
      Display display = wm.getDefaultDisplay();
      Point size = new Point();
      display.getSize(size);
      radius = Math.min(size.x, size.y) / 2;
    }

    int actionBarSize = 0;

    if (getResources().getConfiguration().orientation == Configuration.ORIENTATION_LANDSCAPE) {
      final TypedArray styledAttributes = getContext().getTheme().obtainStyledAttributes(
              new int[]{android.R.attr.actionBarSize});
      actionBarSize = (int) styledAttributes.getDimension(0, 0);
      styledAttributes.recycle();
      marginTopOffset /= 2;
    }

    radius -= marginTopOffset * 2 + actionBarSize;

    int marginTop = 0;
    int marginLeft = 0;
    double rotationAngle = 0;
    FrameLayout.LayoutParams layoutParams;

    for (int i = 0; i < EYES_COUNT; i++) {
      Switch aSwitch = new Switch(getContext());
      aSwitch.setChecked(false);
      aSwitch.setOnCheckedChangeListener(onEyeSwitchChanged);

      rotationAngle = rotationAngleStep * i;
      marginTop = (int) (radius * (1 - Math.cos(rotationAngle)));
      marginLeft = (int) (radius * Math.sin(rotationAngle));
      layoutParams = new LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
      layoutParams.topMargin = marginTop + marginTopOffset;
      layoutParams.leftMargin = marginLeft + radius + marginTopOffset;
      aSwitch.setLayoutParams(layoutParams);

      this.addView(aSwitch);
      eyesSwitches.add(aSwitch);
    }
  }

  private void removeSwitchesFromView() {
    for (Switch sw : eyesSwitches) {
      this.removeView(sw);
    }
    eyesSwitches.clear();
  }


  @Override
  protected void onDetachedFromWindow() {
    removeSwitchesFromView();
    stopShow();
    super.onDetachedFromWindow();
  }

  private CompoundButton.OnCheckedChangeListener onEyeSwitchChanged = new CompoundButton.OnCheckedChangeListener() {
    @Override
    public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
      if (!buttonView.isPressed()) return;

      LoggingHelper.i("EYE_VIEW", "Report eye updated");
      if (delegate != null) {
        delegate.onEyesUpdated(pickStateFromSwitches());
      }
    }
  };
}
