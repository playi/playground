package fragments;

import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.support.annotation.Nullable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ListView;

import org.apache.http.NameValuePair;

import java.util.ArrayList;
import java.util.List;

import controls.ControlInterfaces;
import play_i.playground.R;

/**
 * Created by ilitvinenko on 3/6/15.
 * DataArt
 */
public class SensorsFragment extends BaseFragment {

  private static final int PARAMETER_UPDATE_INTERVAL = 1000; //1sec

  private ControlInterfaces.ISensorsDataSource dataSource;
  private ArrayAdapter<String> listArrayAdapter;
  private Handler updateHandler = new Handler(Looper.getMainLooper());

  public static SensorsFragment newInstance(ControlInterfaces.ISensorsDataSource dataSource) {
    SensorsFragment result = new SensorsFragment();
    result.dataSource = dataSource;
    return result;
  }

  @Override
  public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
    View rootView = inflater.inflate(R.layout.fragment_sensors, container, false);

    listArrayAdapter = new ArrayAdapter<String>(getActivity(), android.R.layout.simple_list_item_1);
    ListView listView = (ListView) rootView.findViewById(R.id.list_view_sensors);
    listView.setAdapter(listArrayAdapter);

    return rootView;
  }

  @Override
  public void onResume() {
    super.onResume();
    startUpdatingSensorsData();
  }

  @Override
  public void onPause() {
    stopUpdatingSensorsData();
    super.onPause();
  }

  private void startUpdatingSensorsData(){
    updateSensorsData();
    updateHandler.postDelayed(new Runnable() {
      @Override
      public void run() {
        startUpdatingSensorsData();
      }
    }, PARAMETER_UPDATE_INTERVAL);
  }

  private void stopUpdatingSensorsData(){
    updateHandler.removeCallbacksAndMessages(null);
  }

  private void updateSensorsData(){
    List<NameValuePair> sensorsData = dataSource.getRobotSensorsData();

    List<String> parameters = new ArrayList<>(sensorsData.size());

    for (NameValuePair pair : sensorsData){
      parameters.add(String.format("%s: %s", pair.getName(), pair.getValue()));
    }

    listArrayAdapter.clear();
    listArrayAdapter.addAll(parameters);
    listArrayAdapter.notifyDataSetChanged();
  }

}
