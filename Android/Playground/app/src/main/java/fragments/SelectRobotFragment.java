package fragments;

import android.content.Context;
import android.graphics.Color;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.support.annotation.Nullable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.TextView;

import com.w2.api.engine.robots.Robot;
import com.w2.api.engine.robots.RobotManager;
import com.w2.api.engine.robots.RobotManagerFactory;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.TimeUnit;

import play_i.playground.R;

/**
 * Created by ilitvinenko on 3/4/15.
 * DataArt
 */
public class SelectRobotFragment extends BaseFragment {

  interface IRobotListItem {
    public String getState();
    public String getName();
    public int getId();
  }

  public interface RobotSelectedDelegate {
    public void onSelected(Robot robot);
  }

  private RobotsListViewAdapter robotListItemArrayAdapter;
  private ListView listView;
  private RobotSelectedDelegate delegate;
  private RobotManager robotManager;
  private Robot connectingRobot;

  private Handler updateHandler = new Handler(Looper.getMainLooper());

  public static SelectRobotFragment newInstance(RobotSelectedDelegate delegate){
    //Not a good solution but to make it simple it's okay
    SelectRobotFragment result = new SelectRobotFragment();
    result.setDelegate(delegate);
    return result;
  }

  @Override
  public void onResume() {
    super.onStart();
    robotManager.startPeriodicScan(1, TimeUnit.SECONDS);
    startUpateingRobots();
  }

  @Override
  public void onPause() {
    robotManager.stopScan();
    stopUpdatingRobots();
    super.onStop();
  }

  private void startUpateingRobots(){
    refreshRobotsList();
    updateHandler.postDelayed(new Runnable() {
      @Override
      public void run() {
        startUpateingRobots();
      }
    }, 1000);
  }

  private void stopUpdatingRobots(){
    updateHandler.removeCallbacksAndMessages(null);
  }

  public void setDelegate(RobotSelectedDelegate delegate) {
    this.delegate = delegate;
  }

  @Override
  public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
    View rootView = inflater.inflate(R.layout.fragment_robots_selection, container, false);

    listView = (ListView) rootView.findViewById(R.id.robots_list_view);

    robotListItemArrayAdapter = new RobotsListViewAdapter(getActivity(), R.layout.robot_list_item, getRobotItemsList());
    listView.setAdapter(robotListItemArrayAdapter);
    listView.setOnItemClickListener(onRobotListViewItemClickListener);
    listView.setEmptyView(rootView.findViewById(R.id.no_robots_text_view));

    rootView.findViewById(R.id.button_refresh).setOnClickListener(onRefreshButtonClickListener);

    robotManager = RobotManagerFactory.getRobotManager(getActivity());

    return rootView;
  }

  private void refreshRobotsList(){
    robotListItemArrayAdapter.clear();
    robotListItemArrayAdapter.addAll(getRobotItemsList());
    robotListItemArrayAdapter.notifyDataSetChanged();
  }

  private List<IRobotListItem> getRobotItemsList(){
    List<Robot> knownRobots = RobotManagerFactory.getRobotManager(getActivity()).getAllKnownRobots();
    List<IRobotListItem> result = new ArrayList<>(knownRobots.size());

    for (final Robot robot : knownRobots){
      result.add(createInterfaceFromRobot(robot));
    }
    return result;
  }

  private IRobotListItem createInterfaceFromRobot(final Robot robot){
    return new IRobotListItem() {
      @Override
      public String getState() {
        String state = "";

        if (robot.isConnected()){
          state = "Connected";
          connectingRobot = null;
        } else {
          if (connectingRobot != null && connectingRobot.isSameRobot(robot)){
            state = "Connecting";
          } else {
            state = "Idle";
          }
        }
        return state;
      }

      @Override
      public String getName() {
        return robot.getName();
      }

      @Override
      public int getId() {
        return robot.getRobotId();
      }
    };
  }

  private AdapterView.OnItemClickListener onRobotListViewItemClickListener = new AdapterView.OnItemClickListener() {
    @Override
    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
      IRobotListItem item = robotListItemArrayAdapter.getItem(position);
      Robot selectedRobot = robotManager.getRobot(item.getId());
      if (selectedRobot != null){
        if (delegate != null) { delegate.onSelected(selectedRobot); }
      }
      connectingRobot = selectedRobot;

      view.setBackgroundColor(Color.YELLOW);
    }
  };

  private View.OnClickListener onRefreshButtonClickListener = new View.OnClickListener() {
    @Override
    public void onClick(View v) {
      refreshRobotsList();
    }
  };

  private static class RobotsListViewAdapter extends ArrayAdapter<IRobotListItem> {

    private static class ViewHolder {
      public TextView statusTextLabel;
      public TextView nameTextLabel;
    }

    private int layoutResourceId;

    public RobotsListViewAdapter(Context context, int resource) {
      super(context, resource);
      this.layoutResourceId = resource;
    }

    private RobotsListViewAdapter(Context context, int resource, List<IRobotListItem> objects) {
      super(context, resource, objects);
      this.layoutResourceId = resource;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {

      if (convertView == null){
        convertView = LayoutInflater.from(getContext()).inflate(layoutResourceId, parent, false);
        ViewHolder holder = new ViewHolder();
        holder.statusTextLabel = (TextView) convertView.findViewById(R.id.state_text_view);
        holder.nameTextLabel = (TextView) convertView.findViewById(R.id.name_text_view);
        convertView.setTag(holder);
      }

      IRobotListItem item = getItem(position);
      ViewHolder holder = (ViewHolder) convertView.getTag();
      holder.statusTextLabel.setText(item.getState());
      holder.nameTextLabel.setText(item.getName());

      int backgroundColor = Color.WHITE;

      if (item.getState() == "Connecting"){
        backgroundColor = Color.YELLOW;
      } else if (item.getState() == "Connected"){
        backgroundColor = Color.GREEN;
      }

      convertView.setBackgroundColor(backgroundColor);

      return convertView;
    }
  }
}
