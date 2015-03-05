package fragments;

import android.content.res.Configuration;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;

import controls.ControlInterfaces;
import play_i.playground.R;
import views.JoystickView;

/**
 * Created by ilitvinenko on 3/5/15.
 * DataArt
 */
public class WheelControlFragment extends BaseFragment {

  private ControlInterfaces.IWheelControl wheelControl;
  private LinearLayout rootLayout;
  private JoystickView joystickView;

  public static WheelControlFragment newInstance(ControlInterfaces.IWheelControl control) {
    WheelControlFragment result = new WheelControlFragment();
    result.wheelControl = control;
    return result;
  }

  @Override
  public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
    rootLayout = (LinearLayout) inflater.inflate(R.layout.fragment_wheel_control, container, false);

    rootLayout.findViewById(R.id.button_start_wiggle).setOnClickListener(onWigglyClickListener);
    rootLayout.findViewById(R.id.button_start_nod).setOnClickListener(onNodClickListener);

    joystickView = (JoystickView) rootLayout.findViewById(R.id.view_joystick);
    joystickView.setDelegate(joystickViewDelegate);

    setRootLayoutOrientation(getResources().getConfiguration().orientation);

    return rootLayout;
  }

  @Override
  public void onConfigurationChanged(Configuration newConfig) {
    setRootLayoutOrientation(newConfig.orientation);
    rootLayout.invalidate();
    joystickView.invalidate();
  }

  private void setRootLayoutOrientation(int screenOrientation){
   rootLayout.setOrientation(screenOrientation == Configuration.ORIENTATION_LANDSCAPE ? LinearLayout.HORIZONTAL : LinearLayout.VERTICAL);
  }

  private View.OnClickListener onNodClickListener = new View.OnClickListener() {
    @Override
    public void onClick(View v) {
      wheelControl.playWiggleAnimation();
    }
  };

  private View.OnClickListener onWigglyClickListener = new View.OnClickListener() {
    @Override
    public void onClick(View v) {
      wheelControl.playNodAnimation();
    }
  };

  private JoystickView.JoystickViewDelegate joystickViewDelegate = new JoystickView.JoystickViewDelegate() {
    @Override
    public void onValueChanged(double linearSpeed, double angle) {
      wheelControl.setWheelAttributes(linearSpeed, angle);
    }
  };
}
