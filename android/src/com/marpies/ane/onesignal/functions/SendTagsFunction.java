/*
 * Copyright 2016 Marcel Piestansky (http://marpies.com)
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.marpies.ane.onesignal.functions;

import com.adobe.fre.FREArray;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;
import com.marpies.ane.onesignal.utils.AIR;
import com.marpies.ane.onesignal.utils.FREObjectUtils;
import com.onesignal.OneSignal;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.List;

public class SendTagsFunction extends BaseFunction {

	@Override
	public FREObject call( FREContext context, FREObject[] args ) {
		super.call( context, args );

		List<String> tagList = FREObjectUtils.getListOfString( (FREArray) args[0] );
		JSONObject tags = new JSONObject();
		for( int i = 0; i < tagList.size(); ) {
			String key = tagList.get( i++ );
			String value = tagList.get( i++ );
			try {
				tags.put( key, value );
			} catch( JSONException e ) {
				e.printStackTrace();
			}
		}
		AIR.log( "OneSignal::sendTags" );
		OneSignal.sendTags( tags );

		return null;
	}

}

