package views;

import android.content.Context;
import android.graphics.Point;
import android.util.AttributeSet;
import android.view.Display;
import android.view.Gravity;
import android.view.MotionEvent;
import android.view.View;
import android.view.WindowManager;
import android.widget.FrameLayout;

import play_i.playground.R;

/**
 * Created by ilitvinenko on 3/5/15.
 * DataArt
 */
public class JoystickView extends SquareFrameLayout {

  private static final double MAXIMUM_SPEED = 90.0;
  private static final double MAX_ANGULAR_SPEED = Math.PI;

  public interface JoystickViewDelegate {
    public void onValueChanged(double linearSpeed, double angle);
  }

  private View control;
  private int circleRadius = 0;
  private JoystickViewDelegate delegate;


  public JoystickView(Context context) {
    super(context);
    initialize();
  }

  public JoystickView(Context context, AttributeSet attrs) {
    super(context, attrs);
    initialize();
  }

  public JoystickView(Context context, AttributeSet attrs, int defStyleAttr) {
    super(context, attrs, defStyleAttr);
    initialize();
  }

  public void setDelegate(JoystickViewDelegate delegate) {
    this.delegate = delegate;
  }

  public double[] getCurrentValues(){
    LayoutParams params = (LayoutParams) control.getLayoutParams();
    double[] values = calculateValues(params.leftMargin, params.topMargin);
    return values;
  }

  private void initialize(){
    if (control != null) {
      this.removeView(control);
    }

    control = new View(getContext());
    control.setBackground(getResources().getDrawable(R.drawable.black_oval));
    int size = getResources().getDimensionPixelSize(R.dimen.stick_control_size);
    FrameLayout.LayoutParams params = new LayoutParams(size, size);
    params.gravity = Gravity.CENTER;

    control.setOnTouchListener(onControlTouchListener);
    this.addView(control, params);

    circleRadius = 0;
  }

  private int getCircleRadius(){
    if (circleRadius > 0) { return circleRadius; }

    int radius = (int) (this.getMeasuredWidth() / 2);

    if (radius <= 0) {
      WindowManager wm = (WindowManager) getContext().getSystemService(Context.WINDOW_SERVICE);
      Display display = wm.getDefaultDisplay();
      Point size = new Point();
      display.getSize(size);
      radius = Math.min(size.x, size.y) / 2;
    }

    circleRadius = (int) (radius * 0.67);
    return circleRadius;
  }

  private void clampValues(LayoutParams params) {
    double newPosRadius = Math.sqrt(params.leftMargin * params.leftMargin + params.topMargin * params.topMargin);
    double proportion = newPosRadius / (getCircleRadius() - params.width / 2);
    if (proportion > 1.0 || proportion < -1.0) {
      params.leftMargin = (int) (params.leftMargin / proportion);
      params.topMargin = (int) (params.topMargin / proportion);
    }
  }

  private void notifyValueUpdated(){

    LayoutParams params = (LayoutParams) control.getLayoutParams();
    double[] values = calculateValues(params.leftMargin, params.topMargin);

    if (delegate != null) {
      delegate.onValueChanged(values[0], values[1]);
    }
  }

  private double[] calculateValues(int xOffset, int yOffset){
    double linearMaxSpeed = MAXIMUM_SPEED;
    int controlSize = getResources().getDimensionPixelSize(R.dimen.stick_control_size);

    double yOffsetNormalized = (double)yOffset / (double)(getCircleRadius() - controlSize / 2);
    double xOffsetNormalized = (double)xOffset / (double)(getCircleRadius() - controlSize / 2);

    double speed = -linearMaxSpeed * yOffsetNormalized;

    double angle = -MAX_ANGULAR_SPEED * xOffsetNormalized;

    return new double[]{speed, angle};
  }

  private OnTouchListener onControlTouchListener = new OnTouchListener() {

    private int initialXOffset, initialYOffset;
    private FrameLayout.LayoutParams params;

    @Override
    public boolean onTouch(View v, MotionEvent event) {
      switch (event.getAction()) {
        case MotionEvent.ACTION_DOWN:
          params = (FrameLayout.LayoutParams) v.getLayoutParams();
          initialXOffset = ((int) event.getRawX()) - params.leftMargin;
          initialYOffset = ((int) event.getRawY()) - params.topMargin;
          return true;
        case MotionEvent.ACTION_MOVE:
          params.leftMargin = ((int) event.getRawX()) - initialXOffset;
          params.topMargin = ((int) event.getRawY()) - initialYOffset;
          clampValues(params);
          v.setLayoutParams(params);
          notifyValueUpdated();
          return true;
        case MotionEvent.ACTION_UP:
        case MotionEvent.ACTION_CANCEL:
          params.leftMargin = params.topMargin = 0;
          v.setLayoutParams(params);
          notifyValueUpdated();
          break;
      }
      return false;
    }
  };
}
