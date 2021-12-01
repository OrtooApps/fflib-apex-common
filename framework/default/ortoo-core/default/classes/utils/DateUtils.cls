// Don't intend to keep this in its current form
public inherited sharing class DateUtils
{

	// Are these *really* required?   Surely standard Salesforce does this?  And in the right locale?
	public static String formatDateToString(Date dateInput)
	{
		String result = '';

		if(dateInput != null)
		{
			String yearString = String.valueOf(dateInput.year());
			String monthString = String.valueOf(dateInput.Month());
			String dayString = String.valueOf(dateInput.day());

			monthString = monthString.length() == 1 ? '0'+monthString : monthString;
			dayString = dayString.length() == 1 ? '0'+dayString : dayString;

			result = yearString+'-'+monthString+'-'+dayString;
		}

		return result;
	}

	public static String formatDateTimeToString(Datetime dateTimeInput)
	{
		String result = '';

		if(dateTimeInput != null)
		{
			String yearString = String.valueOf(dateTimeInput.year());
			String monthString = String.valueOf(dateTimeInput.Month());
			String dayString = String.valueOf(dateTimeInput.day());
			String hourString = String.valueOf(dateTimeInput.hour());
			String minuteString = String.valueOf(dateTimeInput.minute());
			String secondString = String.valueOf(dateTimeInput.second());

			monthString = monthString.length() == 1 ? '0'+monthString : monthString;
			dayString = dayString.length() == 1 ? '0'+dayString : dayString;
			hourString = hourString.length() == 1 ? '0'+hourString : hourString;
			minuteString = minuteString.length() == 1 ? '0'+minuteString : minuteString;
			secondString = secondString.length() == 1 ? '0'+secondString : secondString;

			result = yearString+'-'+monthString+'-'+dayString;

			result += ' '+hourString+':'+minuteString+':'+secondString;
		}

		return result;
	}
}