/**
 * @auth zmm
 * @description des加密与解密实现
 */
package yssoft.utils;

public class DesEncryptUtil {
	private final int[] IP = { 58, 50, 42, 34, 26, 18, 10, 2, 60, 52, 44, 36,
			28, 20, 12, 4, 62, 54, 46, 38, 30, 22, 14, 6, 64, 56, 48, 40, 32,
			24, 16, 8, 57, 49, 41, 33, 25, 17, 9, 1, 59, 51, 43, 35, 27, 19,
			11, 3, 61, 53, 45, 37, 29, 21, 13, 5, 63, 55, 47, 39, 31, 23, 15, 7 }; // 64
	private final int[] IP_1 = { 40, 8, 48, 16, 56, 24, 64, 32, 39, 7, 47, 15,
			55, 23, 63, 31, 38, 6, 46, 14, 54, 22, 62, 30, 37, 5, 45, 13, 53,
			21, 61, 29, 36, 4, 44, 12, 52, 20, 60, 28, 35, 3, 43, 11, 51, 19,
			59, 27, 34, 2, 42, 10, 50, 18, 58, 26, 33, 1, 41, 9, 49, 17, 57, 25 }; // 64
	private final int[] PC_1 = { 57, 49, 41, 33, 25, 17, 9, 1, 58, 50, 42, 34,
			26, 18, 10, 2, 59, 51, 43, 35, 27, 19, 11, 3, 60, 52, 44, 36, 63,
			55, 47, 39, 31, 23, 15, 7, 62, 54, 46, 38, 30, 22, 14, 6, 61, 53,
			45, 37, 29, 21, 13, 5, 28, 20, 12, 4 }; // 56
	private final int[] PC_2 = { 14, 17, 11, 24, 1, 5, 3, 28, 15, 6, 21, 10,
			23, 19, 12, 4, 26, 8, 16, 7, 27, 20, 13, 2, 41, 52, 31, 37, 47, 55,
			30, 40, 51, 45, 33, 48, 44, 49, 39, 56, 34, 53, 46, 42, 50, 36, 29,
			32 }; // 48
	private final int[] E = { 32, 1, 2, 3, 4, 5, 4, 5, 6, 7, 8, 9, 8, 9, 10,
			11, 12, 13, 12, 13, 14, 15, 16, 17, 16, 17, 18, 19, 20, 21, 20, 21,
			22, 23, 24, 25, 24, 25, 26, 27, 28, 29, 28, 29, 30, 31, 32, 1 }; // 48
	private final int[] P = { 16, 7, 20, 21, 29, 12, 28, 17, 1, 15, 23, 26, 5,
			18, 31, 10, 2, 8, 24, 14, 32, 27, 3, 9, 19, 13, 30, 6, 22, 11, 4,
			25 }; // 32
	private final int[][][] S_Box = {
			{ { 14, 4, 13, 1, 2, 15, 11, 8, 3, 10, 6, 12, 5, 9, 0, 7 },
					{ 0, 15, 7, 4, 14, 2, 13, 1, 10, 6, 12, 11, 9, 5, 3, 8 },
					{ 4, 1, 14, 8, 13, 6, 2, 11, 15, 12, 9, 7, 3, 10, 5, 0 },
					{ 15, 12, 8, 2, 4, 9, 1, 7, 5, 11, 3, 14, 10, 0, 6, 13 } },
			{ // S_Box[1]
			{ 15, 1, 8, 14, 6, 11, 3, 4, 9, 7, 2, 13, 12, 0, 5, 10 },
					{ 3, 13, 4, 7, 15, 2, 8, 14, 12, 0, 1, 10, 6, 9, 11, 5 },
					{ 0, 14, 7, 11, 10, 4, 13, 1, 5, 8, 12, 6, 9, 3, 2, 15 },
					{ 13, 8, 10, 1, 3, 15, 4, 2, 11, 6, 7, 12, 0, 5, 14, 9 } },
			{ // S_Box[2]
			{ 10, 0, 9, 14, 6, 3, 15, 5, 1, 13, 12, 7, 11, 4, 2, 8 },
					{ 13, 7, 0, 9, 3, 4, 6, 10, 2, 8, 5, 14, 12, 11, 15, 1 },
					{ 13, 6, 4, 9, 8, 15, 3, 0, 11, 1, 2, 12, 5, 10, 14, 7 },
					{ 1, 10, 13, 0, 6, 9, 8, 7, 4, 15, 14, 3, 11, 5, 2, 12 } },
			{ // S_Box[3]
			{ 7, 13, 14, 3, 0, 6, 9, 10, 1, 2, 8, 5, 11, 12, 4, 15 },
					{ 13, 8, 11, 5, 6, 15, 0, 3, 4, 7, 2, 12, 1, 10, 14, 9 },
					{ 10, 6, 9, 0, 12, 11, 7, 13, 15, 1, 3, 14, 5, 2, 8, 4 },
					{ 3, 15, 0, 6, 10, 1, 13, 8, 9, 4, 5, 11, 12, 7, 2, 14 } },
			{ // S_Box[4]
			{ 2, 12, 4, 1, 7, 10, 11, 6, 8, 5, 3, 15, 13, 0, 14, 9 },
					{ 14, 11, 2, 12, 4, 7, 13, 1, 5, 0, 15, 10, 3, 9, 8, 6 },
					{ 4, 2, 1, 11, 10, 13, 7, 8, 15, 9, 12, 5, 6, 3, 0, 14 },
					{ 11, 8, 12, 7, 1, 14, 2, 13, 6, 15, 0, 9, 10, 4, 5, 3 } },
			{ // S_Box[5]
			{ 12, 1, 10, 15, 9, 2, 6, 8, 0, 13, 3, 4, 14, 7, 5, 11 },
					{ 10, 15, 4, 2, 7, 12, 9, 5, 6, 1, 13, 14, 0, 11, 3, 8 },
					{ 9, 14, 15, 5, 2, 8, 12, 3, 7, 0, 4, 10, 1, 13, 11, 6 },
					{ 4, 3, 2, 12, 9, 5, 15, 10, 11, 14, 1, 7, 6, 0, 8, 13 } },
			{ // S_Box[6]
			{ 4, 11, 2, 14, 15, 0, 8, 13, 3, 12, 9, 7, 5, 10, 6, 1 },
					{ 13, 0, 11, 7, 4, 9, 1, 10, 14, 3, 5, 12, 2, 15, 8, 6 },
					{ 1, 4, 11, 13, 12, 3, 7, 14, 10, 15, 6, 8, 0, 5, 9, 2 },
					{ 6, 11, 13, 8, 1, 4, 10, 7, 9, 5, 0, 15, 14, 2, 3, 12 } },
			{ // S_Box[7]
			{ 13, 2, 8, 4, 6, 15, 11, 1, 10, 9, 3, 14, 5, 0, 12, 7 },
					{ 1, 15, 13, 8, 10, 3, 7, 4, 12, 5, 6, 11, 0, 14, 9, 2 },
					{ 7, 11, 4, 1, 9, 12, 14, 2, 0, 6, 10, 13, 15, 3, 5, 8 },
					{ 2, 1, 14, 7, 4, 10, 8, 13, 15, 12, 9, 0, 3, 5, 6, 11 } } // S_Box[8]
	};
	private final int[] LeftMove = { 1, 1, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2,
			2, 1 };

	public byte[] Des(byte[] des_key, byte[] des_data, int flag) {
		if ((des_key.length != 8) || (des_data.length != 8)
				|| ((flag != 1) && (flag != 0))) {
			return null;
		}
		int flags = flag;
		int[] keydata = new int[64];
		int[] timedata = new int[64];
		byte[] EncryptCode = new byte[8];
		int[][] KeyArray = new int[16][48];
		keydata = ReadDataToInt(des_key);
		timedata = ReadDataToInt(des_data);
		KeyInitialize(keydata, KeyArray);
		EncryptCode = Encrypt(timedata, flags, KeyArray);
		return EncryptCode;
	}

	private int KeyInitialize(int[] key, int[][] keyarray) {
		int i, j;
		int[] K0 = new int[56];
		for (i = 0; i < 56; i++) {
			K0[i] = key[PC_1[i] - 1];
		}
		for (i = 0; i < 16; i++) {
			LeftBitMove(K0, LeftMove[i]);
			for (j = 0; j < 48; j++) {
				keyarray[i][j] = K0[PC_2[j] - 1];
			}
		}
		return 0;
	}

	private byte[] Encrypt(int[] timeData, int flag, int[][] keyarray) {
		int i;
		byte[] encrypt = new byte[8];
		int flags = flag;
		int[] M = new int[64];
		int[] MIP_1 = new int[64];
		for (i = 0; i < 64; i++) {
			M[i] = timeData[IP[i] - 1];
		}
		if (flags == 1) {
			for (i = 0; i < 16; i++) {
				LoopF(M, i, flags, keyarray);
			}
		} else if (flags == 0) {
			for (i = 15; i > -1; i--) {
				LoopF(M, i, flags, keyarray);
			}
		}
		for (i = 0; i < 64; i++) {
			MIP_1[i] = M[IP_1[i] - 1];
		}
		GetEncryptInt(MIP_1, encrypt);
		return encrypt;
	}

	private int[] ReadDataToInt(byte[] intdata) {
		int i, j;
		int[] IntDa = new int[8];
		for (i = 0; i < 8; i++) {
			IntDa[i] = intdata[i];
			if (IntDa[i] < 0) {
				IntDa[i] += 256;
				IntDa[i] %= 256;
			}
		}
		int[] IntVa = new int[64];
		for (i = 0; i < 8; i++) {
			for (j = 0; j < 8; j++) {
				IntVa[((i * 8) + 7) - j] = IntDa[i] % 2;
				IntDa[i] = IntDa[i] / 2;
			}
		}
		return IntVa;
	}

	private int LeftBitMove(int[] k, int offset) {
		int i;
		int[] c0 = new int[28];
		int[] d0 = new int[28];
		int[] c1 = new int[28];
		int[] d1 = new int[28];
		for (i = 0; i < 28; i++) {
			c0[i] = k[i];
			d0[i] = k[i + 28];
		}
		if (offset == 1) {
			for (i = 0; i < 27; i++) {
				c1[i] = c0[i + 1];
				d1[i] = d0[i + 1];
			}
			c1[27] = c0[0];
			d1[27] = d0[0];
		} else if (offset == 2) {
			for (i = 0; i < 26; i++) {
				c1[i] = c0[i + 2];
				d1[i] = d0[i + 2];
			}
			c1[26] = c0[0];
			d1[26] = d0[0];
			c1[27] = c0[1];
			d1[27] = d0[1];
		}
		for (i = 0; i < 28; i++) {
			k[i] = c1[i];
			k[i + 28] = d1[i];
		}
		return 0;
	}

	private int LoopF(int[] M, int times, int flag, int[][] keyarray) {
		int i, j;
		int[] L0 = new int[32];
		int[] R0 = new int[32];
		int[] L1 = new int[32];
		int[] R1 = new int[32];
		int[] RE = new int[48];
		int[][] S = new int[8][6];
		int[] sBoxData = new int[8];
		int[] sValue = new int[32];
		int[] RP = new int[32];
		for (i = 0; i < 32; i++) {
			L0[i] = M[i];
			R0[i] = M[i + 32];
		}
		for (i = 0; i < 48; i++) {
			RE[i] = R0[E[i] - 1];
			RE[i] = RE[i] + keyarray[times][i];
			if (RE[i] == 2) {
				RE[i] = 0;
			}
		}
		for (i = 0; i < 8; i++) {
			for (j = 0; j < 6; j++) {
				S[i][j] = RE[(i * 6) + j];
			}
			sBoxData[i] = S_Box[i][(S[i][0] << 1) + S[i][5]][(S[i][1] << 3)
					+ (S[i][2] << 2) + (S[i][3] << 1) + S[i][4]];
			for (j = 0; j < 4; j++) {
				sValue[((i * 4) + 3) - j] = sBoxData[i] % 2;
				sBoxData[i] = sBoxData[i] / 2;
			}
		}
		for (i = 0; i < 32; i++) {
			RP[i] = sValue[P[i] - 1];
			L1[i] = R0[i];
			R1[i] = L0[i] + RP[i];

			if (R1[i] == 2) {
				R1[i] = 0;
			}
			if (((flag == 0) && (times == 0)) || ((flag == 1) && (times == 15))) {
				M[i] = R1[i];
				M[i + 32] = L1[i];
			} else {
				M[i] = L1[i];
				M[i + 32] = R1[i];
			}
		}
		return 0;
	}

	private int GetEncryptInt(int[] data, byte[] value) {
		int i, j;
		for (i = 0; i < 8; i++) {
			for (j = 0; j < 8; j++) {
				value[i] += (data[(i << 3) + j] << (7 - j));
			}
		}
		for (i = 0; i < 8; i++) {
			value[i] %= 256;
			if (value[i] > 128) {
				value[i] -= 255;
			}
		}
		return 0;
	}

	public static String encodeDes(String str, String key) {
		DesEncryptUtil des = new DesEncryptUtil();
		byte[] bytekey = key.getBytes();
		if (bytekey.length != 8) {
			System.out.println("keybyte len err");
			return null;
		}
		int len = (str.length() % 8 == 0 ? 0 : 8 - str.length() % 8);
		for (int j = 0; j < len; j++) {
			str += " ";
		}
		byte[] bytedata = str.getBytes();

		byte[] result = new byte[bytedata.length];
		for (int i = 0; i < bytedata.length; i += 8) {
			byte[] tt = new byte[8];
			for (int j = 0; j < tt.length; j++)
				tt[j] = bytedata[i + j];
			tt = des.Des(bytekey, tt, 1);
			if (tt == null)
				return null;
			for (int j = 0; j < tt.length; j++)
				result[i + j] = tt[j];
		}
		String s = "";
		for (int i = 0; i < result.length; i++) {
			s += toHexChar(result[i]);
			//System.out.print(result[i] + " ");
		}
		//System.out.println("");
		//System.out.println(s);
		return s;
	}

	public static String toHexChar(byte hex) {
		char[] c = new char[2];
		int hex1 = (hex >> 4) & 0x0f;
		int hex2 = hex & 0x0f;

		if (hex1 < (int) 0x0a) {
			c[0] = (char) ('0' + hex1);
		} else {
			c[0] = (char) ('a' + (hex1 - 0x0a));
		}

		if (hex2 < (int) 0x0a) {
			c[1] = (char) ('0' + hex2);
		} else {
			c[1] = (char) ('a' + (hex2 - 0x0a));
		}

		return new String(c);
	}

	public static byte fromHexChar(String hex) {
		char[] c = new char[2];
		c[0] = hex.charAt(0);
		c[1] = hex.charAt(1);

		byte hex1 = 0, hex2 = 0;
		if (c[0] >= '0' && c[0] <= '9') {
			hex1 = (byte) (c[0] - '0');
		} else if (c[0] >= 'a' && c[0] <= 'z') {
			hex1 = (byte) (0x0a + (c[0] - 'a'));
		}

		if (c[1] >= '0' && c[1] <= '9') {
			hex2 = (byte) (c[1] - '0');
		} else if (c[1] >= 'a' && c[1] <= 'z') {
			hex2 = (byte) (0x0a + (c[1] - 'a'));
		}
		return (byte) ((hex1 << 4) | (hex2 & 0x0f));
	}

	public static String decodeDes(String hex, String key) {
		if(key == null){
			key = DEFAULT_KEY;
		}
		DesEncryptUtil des = new DesEncryptUtil();
		byte[] keybyte = key.getBytes();
		byte[] data = new byte[hex.length() / 2];
		if (keybyte.length != 8 || hex.length() % 2 != 0
				|| data.length % 8 != 0)
			return null;
		for (int i = 0; i < data.length; i++) {
			String nt = hex.substring(i * 2, i * 2 + 2);
			data[i] = fromHexChar(nt);
			//System.out.print(data[i] + " ");
		}
		byte[] result = new byte[data.length];
		for (int i = 0; i < result.length; i += 8) {
			byte[] tt = new byte[8];
			for (int j = 0; j < tt.length; j++)
				tt[j] = data[i + j];
			tt = des.Des(keybyte, tt, 0);
			if (tt == null)
				return null;
			for (int j = 0; j < tt.length; j++)
				result[i + j] = tt[j];
		}
		/*
		 * for(int i=result.length-1;i>=0;i--){ if(result[i]==0x20) result[i] =
		 * 0; else break; }
		 */
		String str = new String(result);
		str = str.trim();
		//System.out.println("decode: ##" + str + "##");
		return str;
	}

	static public String DEFAULT_KEY = "12345678";

	static public void main(String[] args) {
		String key = "12345678";
		//String data = "Zyeap2013";
		String data ="1161";
		//String data ="ys1qaz";
		String enc_data = DesEncryptUtil.encodeDes(data, key);
		System.out.println(enc_data);
		String dec_data = DesEncryptUtil.decodeDes(enc_data, key);
		System.out.println(dec_data);
	}
}