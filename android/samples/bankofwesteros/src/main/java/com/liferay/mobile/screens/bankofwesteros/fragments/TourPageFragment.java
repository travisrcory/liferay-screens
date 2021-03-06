package com.liferay.mobile.screens.bankofwesteros.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

/**
 * @author Javier Gamarra
 */
public class TourPageFragment extends Fragment {

	public static TourPageFragment newInstance(int layout) {

		TourPageFragment tourPageFragment = new TourPageFragment();
		Bundle bundle = new Bundle();
		bundle.putInt(LAYOUT_ID, layout);
		tourPageFragment.setArguments(bundle);

		return tourPageFragment;
	}

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
							 Bundle savedInstanceState) {

		int layoutId = getArguments().getInt(LAYOUT_ID);
		return inflater.inflate(layoutId, container, false);
	}

	private static final String LAYOUT_ID = "layoutId";
}
