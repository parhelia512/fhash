#pragma once

namespace SunJWBase
{
	public ref class NativeHelper sealed
	{
	public:
		NativeHelper();

		System::String^ GetTargetArch();
		System::String^ GetWindowsInfo();
	};
}