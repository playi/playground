package fragments;

import android.content.res.Configuration;
import android.support.v4.app.Fragment;

/**
 * Created by ilitvinenko on 3/4/15.
 * DataArt
 */
public class BaseFragment extends Fragment {

  public static BaseFragment newInstance(){
    return new BaseFragment();
  }

  public void onConfigurationChanged(Configuration newConfig){}
}
