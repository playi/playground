package views;

import android.content.Context;
import android.util.AttributeSet;
import android.widget.FrameLayout;

/**
 * Created by ilitvinenko on 3/5/15.
 * DataArt
 */
public class SquareFrameLayout extends FrameLayout {
  public SquareFrameLayout(Context context) {
    super(context);
  }

  public SquareFrameLayout(Context context, AttributeSet attrs) {
    super(context, attrs);
  }

  public SquareFrameLayout(Context context, AttributeSet attrs, int defStyleAttr) {
    super(context, attrs, defStyleAttr);
  }

  @Override
  protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
    int width = MeasureSpec.getSize(widthMeasureSpec);
    int height = MeasureSpec.getSize(heightMeasureSpec);
    int size = Math.min(width, height);
    super.onMeasure(MeasureSpec.makeMeasureSpec(size, MeasureSpec.EXACTLY),
            MeasureSpec.makeMeasureSpec(size, MeasureSpec.EXACTLY));
  }
}
