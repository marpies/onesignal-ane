/**
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

package com.marpies.ane.onesignal.utils;

import android.os.Bundle;
import com.adobe.fre.*;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

public class FREObjectUtils {

	public static Integer getInt( FREObject object ) {
		try {
			return object.getAsInt();
		} catch( Exception e ) {
			e.printStackTrace();
			return null;
		}
	}

	public static Double getDouble( FREObject object ) {
		try {
			return object.getAsDouble();
		} catch( Exception e ) {
			e.printStackTrace();
			return null;
		}
	}

	public static String getString( FREObject object ) {
		try {
			return object.getAsString();
		} catch( Exception e ) {
			e.printStackTrace();
			return null;
		}
	}

	public static Boolean getBoolean( FREObject object ) {
		try {
			return object.getAsBool();
		} catch( Exception e ) {
			e.printStackTrace();
			return false;
		}
	}

	public static List<String> getListOfString( FREArray array ) {
		List<String> result = new ArrayList<String>();

		try {
			for( long i = 0; i < array.getLength(); i++ ) {
				try {
					result.add( getString( array.getObjectAt( i ) ) );
				} catch( Exception e ) {
					e.printStackTrace();
				}
			}
		} catch( Exception e ) {
			e.printStackTrace();
			return null;
		}

		return result;
	}

	public static String[] getArrayOfString( FREArray array ) {
		String[] result = null;

		try {
			int length = ((Long) array.getLength()).intValue();
			result = new String[length];
			for( int i = 0; i < length; i++ ) {
				try {
					result[i] = getString( array.getObjectAt( (long) i ) );
				} catch( Exception e ) {
					e.printStackTrace();
				}
			}
		} catch( FREInvalidObjectException e ) {
			e.printStackTrace();
		} catch( FREWrongThreadException e ) {
			e.printStackTrace();
		}

		return result;
	}

	public static Bundle getBundle( FREArray array ) {
		Bundle result = null;

		try {
			long length = array.getLength();
			if( length > 0 ) {
				result = new Bundle();
				for( long i = 0; i < length; ) {
					String key = getString( array.getObjectAt( i++ ) );
					String value = getString( array.getObjectAt( i++ ) );
					result.putString( key, value );
				}
			}
		} catch( FREInvalidObjectException e ) {
			e.printStackTrace();
		} catch( FREWrongThreadException e ) {
			e.printStackTrace();
		}

		return result;
	}

	public static JSONObject getJSONObject( FREArray array ) {
		JSONObject result = null;

		try {
			long length = array.getLength();
			if( length > 0 ) {
				result = new JSONObject();
				for( long i = 0; i < length; ) {
					String key = getString( array.getObjectAt( i++ ) );
					String value = getString( array.getObjectAt( i++ ) );
					result.put( key, value );
				}
			}
		} catch( FREInvalidObjectException e ) {
			e.printStackTrace();
		} catch( FREWrongThreadException e ) {
			e.printStackTrace();
		} catch( JSONException e ) {
			e.printStackTrace();
		}

		return result;
	}

	public static FREArray getVectorFromSet( int numElements, boolean fixed, Set<String> set ) {
		try {
			FREArray vector = FREArray.newArray( "String", numElements, fixed );
			long i = 0;
			for( String element : set ) {
				vector.setObjectAt( i++, FREObject.newObject( element ) );
			}
			return vector;
		} catch( FREASErrorException e ) {
			e.printStackTrace();
		} catch( FREWrongThreadException e ) {
			e.printStackTrace();
		} catch( FRENoSuchNameException e ) {
			e.printStackTrace();
		} catch( FREInvalidObjectException e ) {
			e.printStackTrace();
		} catch( FRETypeMismatchException e ) {
			e.printStackTrace();
		}
		return null;
	}

}
