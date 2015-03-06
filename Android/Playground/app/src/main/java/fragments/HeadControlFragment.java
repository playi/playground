package fragments;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import controls.ControlInterfaces;
import play_i.playground.R;

/**
 * Created by ilitvinenko on 3/5/15.
 * DataArt
 */
public class HeadControlFragment extends BaseFragment {

  private ControlInterfaces.IHeadControl headControl;

  public static HeadControlFragment newInstance(ControlInterfaces.IHeadControl control) {
    HeadControlFragment result = new HeadControlFragment();
    result.headControl = control;
    return result;
  }

  @Override
  public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
    View rootView = inflater.inflate(R.layout.fragment_head_control, container, false);

    rootView.findViewById(R.id.button_head_top).setOnClickListener(createOnClickListener(Math.toRadians(90), 0));
    rootView.findViewById(R.id.button_head_left).setOnClickListener(createOnClickListener(0, Math.toRadians(-15)));
    rootView.findViewById(R.id.button_head_middle).setOnClickListener(createOnClickListener(0, 0));
    rootView.findViewById(R.id.button_head_right).setOnClickListener(createOnClickListener(0, Math.toRadians(15)));
    rootView.findViewById(R.id.button_head_bottom).setOnClickListener(createOnClickListener(Math.toRadians(-90), 0));

    return rootView;
  }

  private View.OnClickListener createOnClickListener(final double tilt, final double pan){
    return new View.OnClickListener() {
      @Override
      public void onClick(View v) {
        headControl.setHeadPosition(tilt, pan);
      }
    };
  }
}
